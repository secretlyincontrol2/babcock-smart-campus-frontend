# Smart Campus App Frontend

A Flutter app for the Babcock University Smart Campus system.

## Features

- User authentication and registration
- QR code-based attendance system
- Campus map with Google Maps integration
- Cafeteria menu browsing
- Class schedule management
- Chat system for classmates
- User profile management

## Setup for Railway Deployment

### Prerequisites

1. Flutter SDK installed
2. Railway backend deployed and running

### Configuration

1. **Update API Base URL:**
   - Open `lib/core/constants/app_constants.dart`
   - Change the `baseUrl` to your Railway backend URL:
   ```dart
   static const String baseUrl = 'https://your-railway-url.railway.app';
   ```

2. **Build for Web:**
   ```bash
   flutter build web
   ```

3. **Deploy to Railway:**
   - Create a new Railway project
   - Add a static site service
   - Upload the contents of `build/web/` folder

### Local Development

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run -d chrome
   ```

### Environment Setup

Make sure your Railway backend is running and accessible before testing the frontend.

## Test Credentials

After setting up the backend, you can use these test credentials:

- **Email:** test@babcock.edu
- **Password:** test123

## Building for Production

```bash
# Build for web
flutter build web --release

# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release
```

## Troubleshooting

1. **Network Error:** Make sure the backend URL is correct in `app_constants.dart`
2. **CORS Error:** Ensure your Railway backend has CORS properly configured
3. **Build Errors:** Run `flutter clean` and `flutter pub get` before building 