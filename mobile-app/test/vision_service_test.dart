import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeyafa/core/services/vision_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VisionService Tests', () {
    late VisionService visionService;

    setUp(() {
      visionService = VisionService.instance;
    });

    test('VisionService is a singleton', () {
      final instance1 = VisionService.instance;
      final instance2 = VisionService.instance;
      
      expect(instance1, equals(instance2));
    });

    test('isInitialized returns false initially', () {
      expect(visionService.isInitialized, isFalse);
    });

    test('PoseLandmark fromMap creates correct object', () {
      final map = {
        'x': 0.5,
        'y': 0.6,
        'z': 0.7,
        'visibility': 0.9,
      };

      final landmark = PoseLandmark.fromMap(map);

      expect(landmark.x, equals(0.5));
      expect(landmark.y, equals(0.6));
      expect(landmark.z, equals(0.7));
      expect(landmark.visibility, equals(0.9));
    });

    test('PoseResult fromMap creates correct object', () {
      final map = {
        'landmarks': [
          {'x': 0.1, 'y': 0.2, 'z': 0.3, 'visibility': 0.8},
          {'x': 0.4, 'y': 0.5, 'z': 0.6, 'visibility': 0.9},
        ],
        'timestamp': 1234567890.0,
      };

      final poseResult = PoseResult.fromMap(map);

      expect(poseResult.landmarks.length, equals(2));
      expect(poseResult.timestamp, equals(1234567890.0));
      expect(poseResult.landmarks[0].x, equals(0.1));
      expect(poseResult.landmarks[1].y, equals(0.5));
    });

    test('processFrame throws when not initialized', () async {
      final imageData = Uint8List(100);
      
      expect(
        () async => await visionService.processFrame(imageData, 640, 480),
        throwsException,
      );
    });
  });

  group('Platform Channel Tests', () {
    const MethodChannel channel = MethodChannel('com.qeyafa/mediapipe');
    const EventChannel eventChannel = EventChannel('com.qeyafa/mediapipe_stream');

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'initialize':
            return true;
          case 'startLiveStream':
            return true;
          case 'stopLiveStream':
            return true;
          case 'dispose':
            return true;
          case 'processFrame':
            return <String, dynamic>{
              'landmarks': <Map<String, dynamic>>[
                <String, dynamic>{'x': 0.5, 'y': 0.5, 'z': 0.5, 'visibility': 1.0}
              ],
              'timestamp': DateTime.now().millisecondsSinceEpoch.toDouble(),
            };
          default:
            return null;
        }
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('initialize method channel call', () async {
      final visionService = VisionService.instance;
      
      await visionService.initialize();
      
      expect(visionService.isInitialized, isTrue);
    });

    test('processFrame returns PoseResult', () async {
      final visionService = VisionService.instance;
      await visionService.initialize();
      
      final imageData = Uint8List(100);
      final result = await visionService.processFrame(imageData, 640, 480);
      
      expect(result, isNotNull);
      expect(result!.landmarks.length, equals(1));
      expect(result.landmarks[0].x, equals(0.5));
    });
  });
}
