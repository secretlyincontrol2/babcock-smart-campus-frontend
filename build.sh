#!/bin/bash

# Exit on any error
set -e

echo "🚀 Starting Flutter Web Build for Render..."

# Install Flutter
echo "📦 Installing Flutter..."
FLUTTER_HOME="$HOME/flutter"

# Download Flutter if not already installed
if [ ! -d "$FLUTTER_HOME" ]; then
    echo "⬇️ Downloading Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME
fi

# Add Flutter to PATH
export PATH="$FLUTTER_HOME/bin:$PATH"

# Verify Flutter installation
echo "✅ Flutter version:"
flutter --version

# Enable web support
echo "🌐 Enabling web support..."
flutter config --enable-web

# Get dependencies
echo "📚 Getting dependencies..."
flutter pub get

# Build for web
echo "🔨 Building for web..."
flutter build web --release --web-renderer html

echo "🎉 Build completed successfully!"
echo "📁 Build output: build/web/" 