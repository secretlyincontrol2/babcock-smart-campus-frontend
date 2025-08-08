class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://babcock-smart-campus-backend.onrender.com';
  static const String apiVersion = '/v1';
  static const String refreshTokenKey = 'refresh_token';

  // App Information
  static const String appName = 'Smart Campus';
  static const String universityName = 'Babcock University';
  static const String appVersion = '1.0.0';

  // Default Coordinates (Babcock University, Ilishan-Remo, Ogun State, Nigeria)
  static const double defaultLatitude = 6.5244;
  static const double defaultLongitude = 3.3792;

  // Departments
  static const List<String> departments = [
    'Computer Science',
    'Information Technology',
    'Software Engineering',
    'Computer Engineering',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Chemical Engineering',
    'Business Administration',
    'Accounting',
    'Economics',
    'Mass Communication',
    'Law',
    'Medicine',
    'Nursing',
    'Pharmacy',
    'Agriculture',
    'Education',
    'Arts',
    'Social Sciences'
  ];

  // Levels
  static const List<String> levels = [
    '100',
    '200',
    '300',
    '400',
    '500'
  ];

  // Menu Categories
  static const List<String> menuCategories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Beverages',
    'Desserts'
  ];

  // Location Categories
  static const List<String> locationCategories = [
    'Academic',
    'Administrative',
    'Recreational',
    'Residential',
    'Dining',
    'Transportation',
    'Health',
    'Security'
  ];
} 