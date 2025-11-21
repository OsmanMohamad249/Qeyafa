import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../core/services/vision_service.dart';
import '../../../core/models/pose_landmark.dart';
import '../painters/silhouette_painter.dart';

/// Smart Camera Screen with AR Overlay for body measurement.
///
/// Features:
/// - Real-time camera preview
/// - Orientation detection (phone must be vertical)
/// - AR silhouette guide overlay
/// - Live pose landmark streaming from MediaPipe
class SmartCameraScreen extends StatefulWidget {
  const SmartCameraScreen({super.key});

  @override
  State<SmartCameraScreen> createState() => _SmartCameraScreenState();
}

class _SmartCameraScreenState extends State<SmartCameraScreen> {
  CameraController? _cameraController;
  bool _isProcessing = false;
  bool _isPhoneVertical = true;
  List<PoseLandmark> _currentLandmarks = [];
  double _averageZDepth = 0.0;
  bool _isArabic = true; // Language preference (true = Arabic, false = English)
  
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<List<PoseLandmark>>? _poseSubscription;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeVisionService();
    _startOrientationDetection();
  }

  /// Initialize camera with high resolution
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print('❌ No cameras available');
        return;
      }

      // Use back camera for measurement
      final camera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420, // Efficient for ML
      );

      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() {});
        print('✅ Camera initialized: ${camera.name}');
      }

      // Start streaming camera frames to native code
      // Note: Native MediaPipe will process directly from CameraX/AVFoundation
      // This is a placeholder for triggering the native stream
      _startCameraStream();
    } catch (e) {
      print('❌ Camera initialization failed: $e');
    }
  }

  /// Initialize VisionService for MediaPipe pose detection
  Future<void> _initializeVisionService() async {
    try {
      await VisionService.instance.initialize();
      
      // Subscribe to pose landmark stream
      _poseSubscription = VisionService.instance.poseStream.listen(
        (landmarks) {
          if (mounted && !_isProcessing) {
            setState(() {
              _currentLandmarks = landmarks;
              
              // Calculate average Z-depth from visible landmarks
              if (landmarks.isNotEmpty) {
                final visibleLandmarks = landmarks.where((l) => l.visibility > 0.5);
                if (visibleLandmarks.isNotEmpty) {
                  _averageZDepth = visibleLandmarks
                      .map((l) => l.z)
                      .reduce((a, b) => a + b) / visibleLandmarks.length;
                }
              }
            });
          }
        },
        onError: (error) {
          print('❌ Pose stream error: $error');
        },
      );
      
      print('✅ VisionService initialized and streaming');
    } catch (e) {
      print('❌ VisionService initialization failed: $e');
    }
  }

  /// Start camera stream (trigger native processing)
  void _startCameraStream() {
    // In production: Pass frames to native via MethodChannel
    // For now: Native side will handle CameraX/AVFoundation directly
    print('📷 Camera stream ready for native processing');
  }

  /// Monitor phone orientation using accelerometer
  void _startOrientationDetection() {
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        // Y-axis gravity when phone is vertical (portrait): ~9.8 m/s²
        // Allow ±2.0 tolerance for slight tilts
        final isVertical = event.y > 7.8 && event.y < 11.8;
        
        if (_isPhoneVertical != isVertical) {
          setState(() {
            _isPhoneVertical = isVertical;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _poseSubscription?.cancel();
    _cameraController?.dispose();
    VisionService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background: Camera Preview
          _buildCameraPreview(),
          
          // Middle: AR Silhouette Guide Overlay
          _buildAROverlay(),
          
          // Foreground: Debug Info & Status
          _buildDebugInfo(),
          
          // Top: Instructions
          _buildInstructions(),
        ],
      ),
    );
  }

  /// Camera preview layer
  Widget _buildCameraPreview() {
    return CameraPreview(_cameraController!);
  }

  /// AR overlay with silhouette guide
  Widget _buildAROverlay() {
    return CustomPaint(
      painter: SilhouettePainter(
        isPhoneVertical: _isPhoneVertical,
        landmarks: _currentLandmarks,
      ),
    );
  }

  /// Debug information overlay
  Widget _buildDebugInfo() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusChip(
                  'Status',
                  _currentLandmarks.isNotEmpty ? 'Active' : 'Waiting',
                  _currentLandmarks.isNotEmpty ? Colors.green : Colors.orange,
                ),
                _buildStatusChip(
                  'Z-Depth',
                  _averageZDepth.toStringAsFixed(3),
                  Colors.blue,
                ),
                _buildStatusChip(
                  'Landmarks',
                  '${_currentLandmarks.length}/33',
                  _currentLandmarks.length == 33 ? Colors.green : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Status chip widget
  Widget _buildStatusChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color, width: 1),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Instructions overlay
  Widget _buildInstructions() {
    final instructionText = _isPhoneVertical
        ? (_isArabic 
            ? 'جيد! استمر في الوقوف بشكل مستقيم'
            : 'Good! Keep standing straight')
        : (_isArabic
            ? 'الرجاء حمل الهاتف بشكل عمودي'
            : 'Please hold the phone vertically');
    
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: _isPhoneVertical 
              ? Colors.green.withValues(alpha: 0.8) 
              : Colors.red.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              _isPhoneVertical ? Icons.check_circle : Icons.warning,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    instructionText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!_isPhoneVertical) ...[
                    const SizedBox(height: 4),
                    Text(
                      _isArabic
                          ? 'Hold the phone vertically'
                          : 'الرجاء حمل الهاتف بشكل عمودي',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            // Language toggle button
            IconButton(
              icon: Icon(
                _isArabic ? Icons.translate : Icons.language,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isArabic = !_isArabic;
                });
              },
              tooltip: _isArabic ? 'Switch to English' : 'التبديل للعربية',
            ),
          ],
        ),
      ),
    );
  }
}
