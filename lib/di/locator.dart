import 'package:get_it/get_it.dart';
import 'package:two_zero_four_eight/helpers/shared_preferences.dart';

/// DI locator
GetIt locator = GetIt.instance;

/// Initialize all objects
Future<void> setupLocator() async {
  final sharedPreferences = SharedPreference();
  await sharedPreferences.init();
  locator.registerSingleton(sharedPreferences);
}
