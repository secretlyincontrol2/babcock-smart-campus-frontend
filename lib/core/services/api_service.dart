import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_model.dart';
import '../constants/app_constants.dart';

class ApiService {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.requestTimeout,
      receiveTimeout: AppConstants.requestTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptor for authentication
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        final token = await _secureStorage.read(key: AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 errors by refreshing token
        if (error.response?.statusCode == 401) {
          try {
            final newToken = await refreshToken();
            if (newToken != null) {
              // Retry the original request
              final originalRequest = error.requestOptions;
              originalRequest.headers['Authorization'] = 'Bearer $newToken';
              final response = await _dio.fetch(originalRequest);
              handler.resolve(response);
              return;
            }
          } catch (e) {
            // Token refresh failed, clear storage
            await _secureStorage.delete(key: AppConstants.tokenKey);
          }
        }
        handler.next(error);
      },
    ));
  }

  // Authentication Methods
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        AppConstants.loginEndpoint,
        data: LoginRequest(email: email, password: password).toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserModel> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        AppConstants.registerEndpoint,
        data: request.toJson(),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      final response = await _dio.get(AppConstants.userProfileEndpoint);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserModel> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '${AppConstants.usersEndpoint}/profile',
        data: data,
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<String?> refreshToken() async {
    try {
      final response = await _dio.post(AppConstants.refreshTokenEndpoint);
      final newToken = response.data['access_token'];
      await _secureStorage.write(key: AppConstants.tokenKey, value: newToken);
      return newToken;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Attendance Methods
  Future<List<Map<String, dynamic>>> getClasses() async {
    try {
      final response = await _dio.get(AppConstants.classesEndpoint);
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> scanQrCode(String qrData, {double? latitude, double? longitude}) async {
    try {
      final response = await _dio.post(
        AppConstants.scanQrEndpoint,
        data: {
          'qr_data': qrData,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getMyAttendance({String? startDate, String? endDate}) async {
    try {
      final response = await _dio.get(
        AppConstants.myAttendanceEndpoint,
        queryParameters: {
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getAttendanceStats() async {
    try {
      final response = await _dio.get(AppConstants.attendanceStatsEndpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Schedule Methods
  Future<List<Map<String, dynamic>>> getMySchedule({String? dayOfWeek}) async {
    try {
      final response = await _dio.get(
        AppConstants.scheduleEndpoint,
        queryParameters: {
          if (dayOfWeek != null) 'day_of_week': dayOfWeek,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getTodaySchedule() async {
    try {
      final response = await _dio.get(AppConstants.todayScheduleEndpoint);
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>?> getNextClass() async {
    try {
      final response = await _dio.get(AppConstants.nextClassEndpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Cafeteria Methods
  Future<List<Map<String, dynamic>>> getCafeterias() async {
    try {
      final response = await _dio.get(AppConstants.cafeteriasEndpoint);
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getCafeteriaMenu(int cafeteriaId, {String? category}) async {
    try {
      final response = await _dio.get(
        '${AppConstants.cafeteriasEndpoint}/$cafeteriaId/menu',
        queryParameters: {
          if (category != null) 'category': category,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<String>> getMenuCategories() async {
    try {
      final response = await _dio.get(AppConstants.menuCategoriesEndpoint);
      return List<String>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Maps Methods
  Future<List<Map<String, dynamic>>> getLocations({String? category}) async {
    try {
      final response = await _dio.get(
        AppConstants.locationsEndpoint,
        queryParameters: {
          if (category != null) 'category': category,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getDirections({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
    String mode = 'walking',
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.directionsEndpoint,
        queryParameters: {
          'origin_lat': originLat,
          'origin_lng': originLng,
          'destination_lat': destinationLat,
          'destination_lng': destinationLng,
          'mode': mode,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radius = 1000,
    String? category,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.nearbyEndpoint,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
          if (category != null) 'category': category,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Chat Methods
  Future<List<Map<String, dynamic>>> getChatRooms() async {
    try {
      final response = await _dio.get(AppConstants.chatRoomsEndpoint);
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getChatMessages(int roomId, {int limit = 50, int offset = 0}) async {
    try {
      final response = await _dio.get(
        '${AppConstants.chatMessagesEndpoint}/$roomId/messages',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> sendMessage(int roomId, String message, {String messageType = 'text', String? fileUrl}) async {
    try {
      final response = await _dio.post(
        '${AppConstants.chatMessagesEndpoint}/$roomId/messages',
        data: {
          'message': message,
          'message_type': messageType,
          if (fileUrl != null) 'file_url': fileUrl,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Error handling
  String _handleDioError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('detail')) {
        return data['detail'];
      }
      return 'Server error: ${error.response!.statusCode}';
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Request timeout. Please try again.';
    } else {
      return 'Network error. Please check your connection.';
    }
  }
} 