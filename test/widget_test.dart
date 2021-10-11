import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_zero_four_eight/di/locator.dart';
import 'package:two_zero_four_eight/main.dart';
import 'package:two_zero_four_eight/screens/game_screen.dart';

void main() {
  group('Test the home widget', () {
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });
    testWidgets('Home screen', (widgetTester) async {
      _setMobileSize(widgetTester);
      await widgetTester.pumpWidget(const App2048());
      await widgetTester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) => widget is GameScreen),
          findsOneWidget);
    });
  });
}

Size _setMobileSize(WidgetTester widgetTester) =>
    widgetTester.binding.window.physicalSizeTestValue = const Size(500, 2400);
