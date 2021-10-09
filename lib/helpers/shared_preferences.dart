import 'package:shared_preferences/shared_preferences.dart';

/// Local Storage
class SharedPreference {
  /// Fetch instance
  factory SharedPreference() {
    return _instance;
  }

  /// Constructor
  SharedPreference._internal();

  static final SharedPreference _instance = SharedPreference._internal();

  /// SharedPreferences instance
  late SharedPreferences sharedPreferences;

  /// Initialize Shared Preferences
  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
