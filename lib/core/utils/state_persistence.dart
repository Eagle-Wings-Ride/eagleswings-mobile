import 'package:get_storage/get_storage.dart';

/// State Persistence Manager for saving app state
class StatePersistence {
  static final _storage = GetStorage();

  // Keys
  static const String _selectedChildIdKey = 'selected_child_id';
  static const String _selectedChildNameKey = 'selected_child_name';
  static const String _lastViewedRideIdKey = 'last_viewed_ride_id';
  static const String _filterSelectionKey = 'filter_selection';
  static const String _sortPreferenceKey = 'sort_preference';

  /// Save selected child
  static Future<void> saveSelectedChild({
    required String childId,
    required String childName,
  }) async {
    await _storage.write(_selectedChildIdKey, childId);
    await _storage.write(_selectedChildNameKey, childName);
  }

  /// Get saved child ID
  static String? getSavedChildId() {
    return _storage.read(_selectedChildIdKey);
  }

  /// Get saved child name
  static String? getSavedChildName() {
    return _storage.read(_selectedChildNameKey);
  }

  /// Clear selected child
  static Future<void> clearSelectedChild() async {
    await _storage.remove(_selectedChildIdKey);
    await _storage.remove(_selectedChildNameKey);
  }

  /// Save last viewed ride
  static Future<void> saveLastViewedRide(String rideId) async {
    await _storage.write(_lastViewedRideIdKey, rideId);
  }

  /// Get last viewed ride
  static String? getLastViewedRide() {
    return _storage.read(_lastViewedRideIdKey);
  }

  /// Save filter selection
  static Future<void> saveFilterSelection(String filter) async {
    await _storage.write(_filterSelectionKey, filter);
  }

  /// Get filter selection
  static String getFilterSelection() {
    return _storage.read(_filterSelectionKey) ?? 'all';
  }

  /// Save sort preference
  static Future<void> saveSortPreference(String sort) async {
    await _storage.write(_sortPreferenceKey, sort);
  }

  /// Get sort preference
  static String getSortPreference() {
    return _storage.read(_sortPreferenceKey) ?? 'date_desc';
  }

  /// Clear all saved states
  static Future<void> clearAll() async {
    await _storage.erase();
  }
}

/// Usage in Home Page:
/// 
/// // Save when child is selected
/// await StatePersistence.saveSelectedChild(
///   childId: child.id,
///   childName: child.fullname,
/// );
///
/// // Restore on init
/// final savedChildId = StatePersistence.getSavedChildId();
/// if (savedChildId != null) {
///   setState(() {
///     _selectedChildId = savedChildId;
///     _selectedChildName = StatePersistence.getSavedChildName();
///   });
///   await _loadRecentRides(savedChildId);
/// }