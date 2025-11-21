#!/bin/bash

echo "🚀 Starting MediaPipe Integration Setup..."

# Navigate to mobile-app directory
cd "$(dirname "$0")"

# Step 1: Clean Flutter project
echo "📦 Cleaning Flutter project..."
flutter clean

# Step 2: Remove old dependencies
echo "🗑️  Removing old dependencies..."
rm -f pubspec.lock

# Step 3: Download MediaPipe Heavy Model
echo "📥 Downloading MediaPipe Heavy Model..."
mkdir -p assets/models
curl -L https://storage.googleapis.com/mediapipe-models/pose_landmarker/pose_landmarker_heavy/float16/latest/pose_landmarker_heavy.task \
  -o assets/models/pose_landmarker_heavy.task

if [ -f "assets/models/pose_landmarker_heavy.task" ]; then
    echo "✅ Model downloaded successfully ($(du -h assets/models/pose_landmarker_heavy.task | cut -f1))"
else
    echo "❌ Failed to download model"
    exit 1
fi

# Step 4: Get Flutter dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Step 5: Setup Android
echo "🤖 Setting up Android..."
cd android
./gradlew clean
cd ..

# Step 6: Setup iOS (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Setting up iOS..."
    cd ios
    pod install
    cd ..
else
    echo "⚠️  Skipping iOS setup (not on macOS)"
fi

# Step 7: Verify setup
echo ""
echo "✅ Setup Complete!"
echo ""
echo "📋 Next Steps:"
echo "1. Connect an Android device or start an emulator"
echo "2. Run: flutter run"
echo "3. Test MediaPipe initialization"
echo ""
echo "📖 For more details, see: MEDIAPIPE_INTEGRATION.md"
