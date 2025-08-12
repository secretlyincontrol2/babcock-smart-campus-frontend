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

## Testing with Default Login

The app now includes a **Demo Mode** for easy testing without backend connection:

### Quick Login (Test Credentials)
- **Email:** `test@babcock.edu`
- **Password:** `test123`

### Demo Mode Features
1. **Toggle Demo Mode** on the login screen
2. **Bypass Backend** - Test all app features without server connection
3. **Demo Data** - Pre-populated with realistic campus information
4. **Easy Testing** - No need to set up backend or database

### How to Use Demo Mode
1. Open the app
2. On the login screen, toggle "Demo Mode" to ON
3. Click "Demo Login" button
4. You'll see a blue "Demo Mode" banner at the top
5. Test all features: Maps, Attendance, Schedule, Cafeteria, etc.

### Exiting Demo Mode
- Use the logout button (profile icon in top-right corner)
- Log in with real credentials when backend is available

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
4. **Demo Mode Issues:** If demo mode doesn't work, try logging out and back in
5. **Maps Not Loading:** Ensure you have proper Google Maps API keys configured

## Demo Data Included

The app comes with sample data for testing:

- **Campus Locations:** Library, Student Center, Cafeteria, Admin Building, Science Complex
- **Sample Schedules:** Computer Science, Mathematics, Physics classes
- **Cafeteria Menu:** Breakfast, Lunch, Dinner items
- **Attendance Records:** Sample attendance data
- **User Profile:** Demo student information 