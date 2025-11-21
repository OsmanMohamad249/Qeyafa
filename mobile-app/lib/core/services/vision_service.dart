import 'dart:async';
import 'package:flutter/services.dart';

/// MediaPipe Pose Landmark (33 points with 3D coordinates)
class PoseLandmark {
  final double x;
  final double y;
  final double z; // 3D depth coordinate
  final double visibility;

  PoseLandmark({
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
  });

  factory PoseLandmark.fromMap(Map<String, dynamic> map) {
    return PoseLandmark(
      x: (map['x'] as num).toDouble(),
      y: (map['y'] as num).toDouble(),
      z: (map['z'] as num).toDouble(),
      visibility: (map['visibility'] as num).toDouble(),
    );
  }
}

/// Pose Detection Result
class PoseResult {
  final List<PoseLandmark> landmarks; // 33 landmarks
  final double timestamp;

  PoseResult({
    required this.landmarks,
    required this.timestamp,
  });

  factory PoseResult.fromMap(Map<String, dynamic> map) {
    final landmarksData = (map['landmarks'] as List);
    final landmarks = landmarksData
        .map((lm) => PoseLandmark.fromMap(Map<String, dynamic>.from(lm as Map)))
        .toList();

    return PoseResult(
      landmarks: landmarks,
      timestamp: (map['timestamp'] as num).toDouble(),
    );
  }
}

/// VisionService - Native MediaPipe Integration via Platform Channels
class VisionService {
  static final VisionService _instance = VisionService._internal();
  static VisionService get instance => _instance;
  VisionService._internal();

  static const MethodChannel _channel = MethodChannel('com.qeyafa/mediapipe');
  static const EventChannel _eventChannel = EventChannel('com.qeyafa/mediapipe_stream');

  bool _isInitialized = false;
  StreamSubscription? _poseStreamSubscription;
  final _poseStreamController = StreamController<PoseResult>.broadcast();

  /// Check if MediaPipe is initialized
  bool get isInitialized => _isInitialized;

  /// Stream of pose detection results
  Stream<PoseResult> get poseStream => _poseStreamController.stream;

  /// Initialize MediaPipe with Heavy Model
  Future<void> initialize() async {
    if (_isInitialized) {
      print('✅ VisionService: Already initialized');
      return;
    }

    try {
      print('🔄 VisionService: Initializing native MediaPipe...');
      
      final result = await _channel.invokeMethod('initialize', {
        'modelPath': 'pose_landmarker_heavy.task',
        'delegate': 'CPU', // or 'GPU'
        'numPoses': 1,
        'minDetectionConfidence': 0.75,
        'minPresenceConfidence': 0.75,
        'minTrackingConfidence': 0.7,
        'outputSegmentationMasks': false,
      });

      if (result == true) {
        _isInitialized = true;
        _setupPoseStream();
        print('✅ VisionService: MediaPipe initialized successfully');
      } else {
        throw Exception('Failed to initialize MediaPipe');
      }
    } catch (e, stackTrace) {
      print('❌ VisionService Error: $e');
      print('StackTrace: $stackTrace');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Setup pose detection stream
  void _setupPoseStream() {
    _poseStreamSubscription = _eventChannel.receiveBroadcastStream().listen(
      (data) {
        try {
          final resultMap = Map<String, dynamic>.from(data as Map);
          final poseResult = PoseResult.fromMap(resultMap);
          _poseStreamController.add(poseResult);
        } catch (e) {
          print('❌ Error parsing pose data: $e');
        }
      },
      onError: (error) {
        print('❌ Pose stream error: $error');
      },
    );
  }

  /// Process a single frame (for image mode)
  Future<PoseResult?> processFrame(Uint8List imageData, int width, int height) async {
    if (!_isInitialized) {
      throw Exception('VisionService not initialized');
    }

    try {
      final result = await _channel.invokeMethod('processFrame', {
        'imageData': imageData,
        'width': width,
        'height': height,
      });

      if (result != null) {
        final resultMap = Map<String, dynamic>.from(result as Map);
        return PoseResult.fromMap(resultMap);
      }
      return null;
    } catch (e) {
      print('❌ Error processing frame: $e');
      return null;
    }
  }

  /// Start live stream processing
  Future<void> startLiveStream() async {
    if (!_isInitialized) {
      throw Exception('VisionService not initialized');
    }

    try {
      await _channel.invokeMethod('startLiveStream');
      print('✅ Live stream started');
    } catch (e) {
      print('❌ Error starting live stream: $e');
      rethrow;
    }
  }

  /// Stop live stream processing
  Future<void> stopLiveStream() async {
    try {
      await _channel.invokeMethod('stopLiveStream');
      print('✅ Live stream stopped');
    } catch (e) {
      print('❌ Error stopping live stream: $e');
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    print('🔄 VisionService: Disposing resources...');
    
    await stopLiveStream();
    await _poseStreamSubscription?.cancel();
    await _poseStreamController.close();

    try {
      await _channel.invokeMethod('dispose');
      _isInitialized = false;
      print('✅ VisionService: Disposed successfully');
    } catch (e) {
      print('❌ Error disposing VisionService: $e');
    }
  }
}
