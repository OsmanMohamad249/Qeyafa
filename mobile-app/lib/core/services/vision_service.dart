import 'dart:async';
import 'package:flutter/services.dart';
import '../models/pose_landmark.dart';

/// Singleton service that bridges Flutter to Native MediaPipe implementation.
///
/// This service communicates with Android (Kotlin) and iOS (Swift) native code
/// through Platform Channels to perform real-time pose detection using MediaPipe.
class VisionService {
  VisionService._();
  static final VisionService instance = VisionService._();

  // Platform Channels
  static const MethodChannel _methodChannel = MethodChannel('com.qeyafa.app/vision');
  static const EventChannel _eventChannel = EventChannel('com.qeyafa.app/vision_stream');

  Stream<List<PoseLandmark>>? _poseStream;
  bool _isInitialized = false;

  /// Initializes the native MediaPipe Pose Landmarker.
  ///
  /// Must be called before using [poseStream].
  /// Throws [PlatformException] if initialization fails.
  Future<void> initialize() async {
    if (_isInitialized) {
      print('⚠️ VisionService already initialized');
      return;
    }

    try {
      print('🚀 Initializing native MediaPipe...');
      await _methodChannel.invokeMethod('init');
      _isInitialized = true;
      print('✅ MediaPipe initialized successfully');
    } on PlatformException catch (e) {
      print('❌ Failed to initialize MediaPipe: ${e.message}');
      print('   Code: ${e.code}, Details: ${e.details}');
      rethrow;
    } catch (e) {
      print('❌ Unexpected error during initialization: $e');
      rethrow;
    }
  }

  /// Stream of pose detection results.
  ///
  /// Each emission contains a list of 33 [PoseLandmark] objects representing
  /// the full body pose in 3D space.
  ///
  /// Call [initialize] before accessing this stream.
  Stream<List<PoseLandmark>> get poseStream {
    if (!_isInitialized) {
      throw StateError('VisionService must be initialized before accessing poseStream');
    }

    _poseStream ??= _eventChannel.receiveBroadcastStream().map((event) {
      try {
        if (event == null) {
          print('⚠️ Received null event from native');
          return <PoseLandmark>[];
        }

        // Event should be a List of Maps
        final List<dynamic> landmarkMaps = event as List<dynamic>;
        
        final landmarks = landmarkMaps
            .map((map) => PoseLandmark.fromMap(map as Map<dynamic, dynamic>))
            .toList();

        print('📍 Received ${landmarks.length} landmarks');
        return landmarks;
      } catch (e) {
        print('❌ Error parsing pose data: $e');
        return <PoseLandmark>[];
      }
    });

    return _poseStream!;
  }

  /// Stops the pose detection stream and releases native resources.
  Future<void> dispose() async {
    try {
      await _methodChannel.invokeMethod('dispose');
      _isInitialized = false;
      _poseStream = null;
      print('🛑 VisionService disposed');
    } on PlatformException catch (e) {
      print('⚠️ Error disposing VisionService: ${e.message}');
    }
  }

  /// Checks if the service is initialized.
  bool get isInitialized => _isInitialized;
}
