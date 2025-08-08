import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../../core/constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _token != null && _user != null;

  // Initialize auth state
  Future<void> initialize() async {
    _isLoading = true;
    // Don't call notifyListeners here to avoid setState during build

    try {
      // Check for stored token
      final storedToken = await _secureStorage.read(key: AppConstants.tokenKey);
      if (storedToken != null) {
        _token = storedToken;
        
        // Get user profile
        final userData = await _apiService.getUserProfile();
        _user = userData;
      }
    } catch (e) {
      // Clear invalid token
      await _secureStorage.delete(key: AppConstants.tokenKey);
      _token = null;
      _user = null;
    } finally {
      _isLoading = false;
      // Only notify listeners after the widget is built
      Future.microtask(() => notifyListeners());
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      _token = response.accessToken;
      _user = response.user;

      // Store token securely
      await _secureStorage.write(
        key: AppConstants.tokenKey,
        value: _token,
      );

      // Store user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userKey, response.user.toJson().toString());
      await prefs.setBool(AppConstants.isLoggedInKey, true);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(RegisterRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _apiService.register(request);
      _user = user;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Clear secure storage
      await _secureStorage.delete(key: AppConstants.tokenKey);
      
      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userKey);
      await prefs.setBool(AppConstants.isLoggedInKey, false);
      
      // Clear state
      _token = null;
      _user = null;
      _error = null;
    } catch (e) {
      // Handle error silently
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? department,
    String? level,
    String? phoneNumber,
    String? profilePicture,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = await _apiService.updateUserProfile({
        if (fullName != null) 'full_name': fullName,
        if (department != null) 'department': department,
        if (level != null) 'level': level,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (profilePicture != null) 'profile_picture': profilePicture,
      });

      _user = updatedUser;
      
      // Update stored user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userKey, updatedUser.toJson().toString());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final newToken = await _apiService.refreshToken();
      _token = newToken;
      
      await _secureStorage.write(
        key: AppConstants.tokenKey,
        value: _token,
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 