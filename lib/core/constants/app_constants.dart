class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://babcock-smart-campus-backend.onrender.com';
  static const String apiVersion = '/v1';
  static const String refreshTokenKey = 'refresh_token';
  
  // Storage Keys
  static const String tokenKey = 'access_token';
  static const String userKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  
  // Request Timeout
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String userProfileEndpoint = '/auth/me';
  static const String usersEndpoint = '/users';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String classesEndpoint = '/attendance/classes';
  static const String scanQrEndpoint = '/attendance/scan';
  static const String myAttendanceEndpoint = '/attendance/my-attendance';
  static const String attendanceStatsEndpoint = '/attendance/stats';
  static const String scheduleEndpoint = '/schedule';
  static const String todayScheduleEndpoint = '/schedule/today';
  static const String nextClassEndpoint = '/schedule/next-class';
  static const String cafeteriasEndpoint = '/cafeteria/cafeterias';
  static const String menuCategoriesEndpoint = '/cafeteria/menu/categories';
  static const String locationsEndpoint = '/maps/locations';
  static const String directionsEndpoint = '/maps/directions';
  static const String nearbyEndpoint = '/maps/nearby';
  static const String chatRoomsEndpoint = '/chat/rooms';
  static const String chatMessagesEndpoint = '/chat';

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