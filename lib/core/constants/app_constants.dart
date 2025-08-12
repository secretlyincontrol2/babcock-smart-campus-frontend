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
  
  // API Endpoints - Updated to match backend router prefixes
  
  // Authentication Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String userProfileEndpoint = '/auth/me';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String verifyEmailEndpoint = '/auth/verify-email';
  static const String resendVerificationEndpoint = '/auth/resend-verification';
  
  // User Management Endpoints
  static const String usersEndpoint = '/users';
  static const String userProfileUpdateEndpoint = '/users/profile';
  static const String userAvatarEndpoint = '/users/avatar';
  static const String userStatsEndpoint = '/users/stats';
  static const String userSearchEndpoint = '/users/search';
  static const String userBulkEndpoint = '/users/bulk';
  static const String userExportEndpoint = '/users/export';
  
  // Attendance Endpoints
  static const String attendanceBaseEndpoint = '/attendance';
  static const String classesEndpoint = '/attendance/classes';
  static const String classCreateEndpoint = '/attendance/classes';
  static const String classUpdateEndpoint = '/attendance/classes/{class_id}';
  static const String classDeleteEndpoint = '/attendance/classes/{class_id}';
  static const String classDetailsEndpoint = '/attendance/classes/{class_id}';
  static const String classAttendanceEndpoint = '/attendance/classes/{class_id}/attendance';
  static const String scanQrEndpoint = '/attendance/scan';
  static const String generateQrEndpoint = '/attendance/generate-qr';
  static const String validateQrEndpoint = '/attendance/validate-qr';
  static const String myAttendanceEndpoint = '/attendance/my-attendance';
  static const String attendanceStatsEndpoint = '/attendance/stats';
  static const String attendanceReportEndpoint = '/attendance/reports';
  static const String attendanceExportEndpoint = '/attendance/export';
  static const String attendanceBulkEndpoint = '/attendance/bulk';
  
  // Schedule Endpoints
  static const String scheduleBaseEndpoint = '/schedule';
  static const String scheduleCreateEndpoint = '/schedule';
  static const String scheduleUpdateEndpoint = '/schedule/{schedule_id}';
  static const String scheduleDeleteEndpoint = '/schedule/{schedule_id}';
  static const String scheduleDetailsEndpoint = '/schedule/{schedule_id}';
  static const String myScheduleEndpoint = '/schedule/my-schedule';
  static const String todayScheduleEndpoint = '/schedule/today';
  static const String nextClassEndpoint = '/schedule/next-class';
  static const String scheduleConflictsEndpoint = '/schedule/conflicts';
  static const String scheduleStatsEndpoint = '/schedule/stats';
  static const String scheduleExportEndpoint = '/schedule/export';
  static const String scheduleBulkEndpoint = '/schedule/bulk';
  
  // Cafeteria Endpoints
  static const String cafeteriaBaseEndpoint = '/cafeteria';
  static const String cafeteriasEndpoint = '/cafeteria/cafeterias';
  static const String cafeteriaCreateEndpoint = '/cafeteria/cafeterias';
  static const String cafeteriaUpdateEndpoint = '/cafeteria/cafeterias/{cafeteria_id}';
  static const String cafeteriaDeleteEndpoint = '/cafeteria/cafeterias/{cafeteria_id}';
  static const String cafeteriaDetailsEndpoint = '/cafeteria/cafeterias/{cafeteria_id}';
  static const String cafeteriaMenuEndpoint = '/cafeteria/cafeterias/{cafeteria_id}/menu';
  static const String foodItemsEndpoint = '/cafeteria/food-items';
  static const String foodItemCreateEndpoint = '/cafeteria/food-items';
  static const String foodItemUpdateEndpoint = '/cafeteria/food-items/{item_id}';
  static const String foodItemDeleteEndpoint = '/cafeteria/food-items/{item_id}';
  static const String menuDaysEndpoint = '/cafeteria/menu-days';
  static const String menuDayCreateEndpoint = '/cafeteria/menu-days';
  static const String menuDayUpdateEndpoint = '/cafeteria/menu-days/{day_id}';
  static const String menuDayDeleteEndpoint = '/cafeteria/menu-days/{day_id}';
  static const String cafeteriaQrEndpoint = '/cafeteria/qr-code';
  static const String cafeteriaQrScanEndpoint = '/cafeteria/qr-scan';
  static const String cafeteriaStatsEndpoint = '/cafeteria/stats';
  static const String cafeteriaExportEndpoint = '/cafeteria/export';
  
  // Maps Endpoints
  static const String mapsBaseEndpoint = '/maps';
  static const String locationsEndpoint = '/maps/locations';
  static const String locationCreateEndpoint = '/maps/locations';
  static const String locationUpdateEndpoint = '/maps/locations/{location_id}';
  static const String locationDeleteEndpoint = '/maps/locations/{location_id}';
  static const String locationDetailsEndpoint = '/maps/locations/{location_id}';
  static const String directionsEndpoint = '/maps/directions';
  static const String nearbyEndpoint = '/maps/nearby';
  static const String campusInfoEndpoint = '/maps/campus-info';
  static const String locationSearchEndpoint = '/maps/locations/search';
  static const String locationCategoriesEndpoint = '/maps/locations/categories';
  static const String locationStatsEndpoint = '/maps/locations/stats';
  static const String locationExportEndpoint = '/maps/locations/export';
  
  // Chat Endpoints
  static const String chatBaseEndpoint = '/chat';
  static const String chatRoomsEndpoint = '/chat/rooms';
  static const String chatRoomCreateEndpoint = '/chat/rooms';
  static const String chatRoomDetailsEndpoint = '/chat/rooms/{room_id}';
  static const String chatRoomUpdateEndpoint = '/chat/rooms/{room_id}';
  static const String chatRoomDeleteEndpoint = '/chat/rooms/{room_id}';
  static const String chatMessagesEndpoint = '/chat/rooms/{room_id}/messages';
  static const String chatMessageSendEndpoint = '/chat/rooms/{room_id}/messages';
  static const String chatMessageUpdateEndpoint = '/chat/messages/{message_id}';
  static const String chatMessageDeleteEndpoint = '/chat/messages/{message_id}';
  static const String chatUnreadCountEndpoint = '/chat/messages/unread';
  static const String chatMarkReadEndpoint = '/chat/messages/{message_id}/read';
  static const String chatClassmatesEndpoint = '/chat/classmates';
  static const String chatExportEndpoint = '/chat/export';
  
  // Health and Info Endpoints
  static const String healthEndpoint = '/health';
  static const String dbStatusEndpoint = '/db-status';
  static const String apiInfoEndpoint = '/info';
  
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
  
  // Helper method to build dynamic endpoints
  static String buildEndpoint(String baseEndpoint, Map<String, String> params) {
    String endpoint = baseEndpoint;
    params.forEach((key, value) {
      endpoint = endpoint.replaceAll('{$key}', value);
    });
    return endpoint;
  }
  
  // Helper method to get full API URL
  static String getApiUrl(String endpoint) {
    return baseUrl + endpoint;
  }
} 