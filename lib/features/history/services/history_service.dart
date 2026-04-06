import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class HistoryService {
  static const String _storageKey = 'tslr_history';
  final SharedPreferences _prefs;

  HistoryService(this._prefs);

  // Get all history items
  Future<List<HistoryItem>> getHistory() async {
    try {
      final jsonString = _prefs.getString(_storageKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((item) => HistoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting history: $e');
      return [];
    }
  }

  // Add a new history item
  Future<void> addHistoryItem(HistoryItem item) async {
    try {
      final currentHistory = await getHistory();
      currentHistory.insert(0, item); // Add to beginning

      // Keep only last 100 items
      if (currentHistory.length > 100) {
        currentHistory.removeRange(100, currentHistory.length);
      }

      final jsonList = currentHistory.map((item) => item.toJson()).toList();
      await _prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error adding history item: $e');
    }
  }

  // Delete a history item by ID
  Future<void> deleteHistoryItem(String id) async {
    try {
      final currentHistory = await getHistory();
      currentHistory.removeWhere((item) => item.id == id);

      final jsonList = currentHistory.map((item) => item.toJson()).toList();
      await _prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error deleting history item: $e');
    }
  }

  // Clear all history
  Future<void> clearHistory() async {
    try {
      await _prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing history: $e');
    }
  }

  // Get history items by date range
  Future<List<HistoryItem>> getHistoryByDateRange(
      DateTime start, DateTime end) async {
    try {
      final history = await getHistory();
      return history
          .where((item) =>
              item.timestamp.isAfter(start) && item.timestamp.isBefore(end))
          .toList();
    } catch (e) {
      print('Error getting history by date range: $e');
      return [];
    }
  }

  // Search history items
  Future<List<HistoryItem>> searchHistory(String query) async {
    try {
      final history = await getHistory();
      return history
          .where((item) =>
              item.recognizedText
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              item.alternatives.any((alt) =>
                  alt.toLowerCase().contains(query.toLowerCase())))
          .toList();
    } catch (e) {
      print('Error searching history: $e');
      return [];
    }
  }
}
