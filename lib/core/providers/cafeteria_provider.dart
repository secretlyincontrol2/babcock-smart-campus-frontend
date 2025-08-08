import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CafeteriaProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _cafeterias = [];
  List<Map<String, dynamic>> _menuItems = [];
  List<String> _menuCategories = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get cafeterias => _cafeterias;
  List<Map<String, dynamic>> get menuItems => _menuItems;
  List<String> get menuCategories => _menuCategories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load cafeterias
  Future<void> loadCafeterias() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cafeterias = await _apiService.getCafeterias();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load cafeteria menu
  Future<void> loadCafeteriaMenu(int cafeteriaId, {String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _menuItems = await _apiService.getCafeteriaMenu(cafeteriaId, category: category);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load menu categories
  Future<void> loadMenuCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _menuCategories = await _apiService.getMenuCategories();
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