#!/bin/bash

# Exit on any error
set -e

echo "🚀 Starting Flutter Web Build for Render..."

# Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Install Flutter
echo "📦 Installing Flutter..."
FLUTTER_VERSION="3.19.6"
FLUTTER_HOME="$HOME/flutter"

# Download Flutter if not already installed
if [ ! -d "$FLUTTER_HOME" ]; then
    echo "⬇️ Downloading Flutter $FLUTTER_VERSION..."
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