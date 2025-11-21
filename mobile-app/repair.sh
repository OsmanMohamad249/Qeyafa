#!/bin/bash
echo "Cleaning project..."
flutter clean
echo "Removing old lock file..."
rm -f pubspec.lock
echo "Getting packages..."
flutter pub get
echo "Done! Run the app now."