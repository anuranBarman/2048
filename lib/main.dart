import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:two_zero_four_eight/cubit/game_cubit.dart';
import 'package:two_zero_four_eight/home.dart';
import 'package:two_zero_four_eight/screens/game_screen.dart';

void main() => runApp(const App2048());

///Main App
class App2048 extends StatelessWidget {
  /// Constructor
  const App2048({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'StarJedi'),
      home: Sizer(builder: (context, orientation, deviceType) {
        SizerUtil.orientation = orientation;
        return BlocProvider(
          create: (context) => GameCubit(currentGrid: []),
          //child: HomePage(),
          child: const GameScreen(),
        );
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}
