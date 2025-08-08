import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ScheduleProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _mySchedule = [];
  List<Map<String, dynamic>> _todaySchedule = [];
  Map<String, dynamic>? _nextClass;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get mySchedule => _mySchedule;
  List<Map<String, dynamic>> get todaySchedule => _todaySchedule;
  Map<String, dynamic>? get nextClass => _nextClass;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load my schedule
  Future<void> loadMySchedule({String? dayOfWeek}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _mySchedule = await _apiService.getMySchedule(dayOfWeek: dayOfWeek);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load today's schedule
  Future<void> loadTodaySchedule() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _todaySchedule = await _apiService.getTodaySchedule();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load next class
  Future<void> loadNextClass() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _nextClass = await _apiService.getNextClass();
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