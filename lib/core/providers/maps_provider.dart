import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MapsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _locations = [];
  List<Map<String, dynamic>> _nearbyLocations = [];
  Map<String, dynamic>? _directions;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get locations => _locations;
  List<Map<String, dynamic>> get nearbyLocations => _nearbyLocations;
  Map<String, dynamic>? get directions => _directions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load locations
  Future<void> loadLocations({String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _locations = await _apiService.getLocations(category: category);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get directions
  Future<void> getDirections({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
    String mode = 'walking',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _directions = await _apiService.getDirections(
        originLat: originLat,
        originLng: originLng,
        destinationLat: destinationLat,
        destinationLng: destinationLng,
        mode: mode,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get nearby locations
  Future<void> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radius = 1000,
    String? category,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _nearbyLocations = await _apiService.getNearbyLocations(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        category: category,
      );
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