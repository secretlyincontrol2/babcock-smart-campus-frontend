import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _chatRooms = [];
  List<Map<String, dynamic>> _messages = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get chatRooms => _chatRooms;
  List<Map<String, dynamic>> get messages => _messages;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load chat rooms
  Future<void> loadChatRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _chatRooms = await _apiService.getChatRooms();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load chat messages
  Future<void> loadChatMessages(int roomId, {int limit = 50, int offset = 0}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _messages = await _apiService.getChatMessages(roomId, limit: limit, offset: offset);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Send message
  Future<bool> sendMessage(int roomId, String message, {String messageType = 'text', String? fileUrl}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.sendMessage(roomId, message, messageType: messageType, fileUrl: fileUrl);
      // Reload messages after sending
      await loadChatMessages(roomId);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load unread count
  Future<void> loadUnreadCount() async {
    try {
      // This would be implemented when the backend supports it
      // For now, we'll set it to 0
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      // Handle error silently
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 