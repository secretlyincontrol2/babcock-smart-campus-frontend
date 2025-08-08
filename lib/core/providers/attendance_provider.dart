import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AttendanceProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _classes = [];
  List<Map<String, dynamic>> _myAttendance = [];
  Map<String, dynamic>? _attendanceStats;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get classes => _classes;
  List<Map<String, dynamic>> get myAttendance => _myAttendance;
  Map<String, dynamic>? get attendanceStats => _attendanceStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load classes
  Future<void> loadClasses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _classes = await _apiService.getClasses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Scan QR code
  Future<bool> scanQrCode(String qrData, {double? latitude, double? longitude}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.scanQrCode(qrData, latitude: latitude, longitude: longitude);
      // Reload attendance data after successful scan
      await loadMyAttendance();
      await loadAttendanceStats();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load my attendance
  Future<void> loadMyAttendance({String? startDate, String? endDate}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myAttendance = await _apiService.getMyAttendance(startDate: startDate, endDate: endDate);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load attendance statistics
  Future<void> loadAttendanceStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _attendanceStats = await _apiService.getAttendanceStats();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 