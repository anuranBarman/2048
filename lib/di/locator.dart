import 'package:get_it/get_it.dart';
import 'package:two_zero_four_eight/helpers/shared_preferences.dart';

/// DI locator
GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = SharedPreference().init();
  locator.registerSingleton(sharedPreferences);
}
