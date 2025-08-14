#!/bin/bash

# Smart Campus App Build Script for Render
echo "🚀 Starting Smart Campus App build..."

# Check if Flutter is already available
if [ -d "$HOME/flutter" ]; then
    echo "✅ Flutter already exists, using existing installation"
    export PATH="$HOME/flutter/bin:$PATH"
else
    echo "📥 Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter
    export PATH="$HOME/flutter/bin:$PATH"
fi

# Verify Flutter installation
echo "🔍 Checking Flutter version..."
flutter --version

# Configure Flutter for web
echo "🌐 Configuring Flutter for web..."
flutter config --enable-web

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Build web app
echo "🏗️ Building web app..."
flutter build web --release

echo "✅ Build completed successfully!"
echo "📁 Build output: ./build/web" 