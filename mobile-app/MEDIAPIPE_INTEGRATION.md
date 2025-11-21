# MediaPipe Integration Guide

## Overview
This project integrates the official MediaPipe library (from your repository: https://github.com/OsmanMohamad249/mediapipe) directly into the Flutter app using Platform Channels.

## Features
✅ **33 3D Pose Landmarks** - Full body tracking with (x, y, z) coordinates
✅ **Heavy Model Support** - High precision pose detection
✅ **Live Stream Mode** - Real-time pose tracking
✅ **Platform Channels** - Native Android/iOS integration
✅ **No Third-Party Dependencies** - Direct MediaPipe integration

## Architecture

```
Flutter (Dart)
    ↕️ Platform Channels
Native Layer (Kotlin/Swift)
    ↕️ JNI/FFI
MediaPipe C++ Library
```

## Setup Instructions

### 1. Add MediaPipe Model to Assets
```bash
# Download the Heavy model
curl -L https://storage.googleapis.com/mediapipe-models/pose_landmarker/pose_landmarker_heavy/float16/latest/pose_landmarker_heavy.task \
  -o mobile-app/assets/models/pose_landmarker_heavy.task
```

### 2. Android Setup

#### Update `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.mediapipe:tasks-vision:0.10.14'
}
```

#### Add MediaPipe Plugin:
File: `android/app/src/main/kotlin/com/qeyafa/mobile/MediaPipePlugin.kt`
(Already created ✅)

### 3. iOS Setup

#### Update `ios/Podfile`:
```ruby
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  
  # Add MediaPipe
  pod 'MediaPipeTasksVision', '~> 0.10.14'
end
```

#### Add Model to iOS:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Drag `pose_landmarker_heavy.task` to `Runner` → `Resources`
3. Check "Copy items if needed"

### 4. Usage Example

```dart
import 'package:qeyafa/core/services/vision_service.dart';

// Initialize
await VisionService.instance.initialize();

// Listen to pose stream
VisionService.instance.poseStream.listen((poseResult) {
  for (var landmark in poseResult.landmarks) {
    print('Point: (${landmark.x}, ${landmark.y}, ${landmark.z})');
  }
});

// Start live stream
await VisionService.instance.startLiveStream();

// Process single frame
final result = await VisionService.instance.processFrame(
  imageData, width, height
);
```

## Landmark Indices (33 points)

```
0: nose
1-10: face contour
11-12: shoulders
13-14: elbows
15-16: wrists
17-22: hands
23-24: hips
25-26: knees
27-28: ankles
29-32: feet
```

## 3D Coordinates
- **x**: Horizontal position (0-1, normalized)
- **y**: Vertical position (0-1, normalized)
- **z**: Depth (meters from camera, real-world scale)
- **visibility**: Confidence score (0-1)

## Next Steps

### Immediate:
1. ✅ Run `flutter clean && flutter pub get`
2. ✅ Download the Heavy model
3. ✅ Test on Android device

### Integration with Your MediaPipe Repo:
To use your custom MediaPipe build from https://github.com/OsmanMohamad249/mediapipe:

#### Option A: Use Pre-built AAR/Framework
1. Build MediaPipe for Android:
   ```bash
   cd /path/to/your/mediapipe
   bazel build -c opt --config=android_arm64 mediapipe/tasks/java/com/google/mediapipe/tasks/vision:vision
   ```

2. Copy the `.aar` file to `android/app/libs/`

3. Update `android/app/build.gradle`:
   ```gradle
   dependencies {
       implementation files('libs/mediapipe-tasks-vision.aar')
   }
   ```

#### Option B: Build as Submodule
1. Add as git submodule:
   ```bash
   git submodule add https://github.com/OsmanMohamad249/mediapipe mobile-app/mediapipe
   ```

2. Build and link in Gradle/CocoaPods

## Troubleshooting

### Android Errors:
- **Min SDK < 24**: Update `minSdkVersion` to 24
- **Missing AAR**: Check Gradle dependencies
- **Model not found**: Verify `assets/models/` path

### iOS Errors:
- **Podfile issues**: Run `pod install`
- **Model not bundled**: Check Xcode resources
- **Swift version**: Ensure Swift 5.0+

## Performance Tips
- Use **GPU delegate** on devices with strong GPUs
- Reduce `numPoses` to 1 for single-person tracking
- Lower confidence thresholds if needed (not recommended for precision)

## Support
- MediaPipe Docs: https://developers.google.com/mediapipe
- Your Repo: https://github.com/OsmanMohamad249/mediapipe
- Flutter Docs: https://docs.flutter.dev/platform-integration/platform-channels
