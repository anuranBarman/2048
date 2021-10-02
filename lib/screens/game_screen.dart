import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_zero_four_eight/cubit/game_cubit.dart';

///Game Home screen
class GameScreen extends StatefulWidget {
  ///Constructor
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SizedBox.expand(
            child: GestureDetector(
                child: Container(),
                onPanUpdate: (details) {
                  if (details.delta.dx > 0) {
                    context.read<GameCubit>().onRight();
                  } else if (details.delta.dx < 0) {
                    context.read<GameCubit>().onLeft();
                  } else if (details.delta.dy > 0) {
                    context.read<GameCubit>().onUp();
                  } else if (details.delta.dy < 0) {
                    context.read<GameCubit>().onDown();
                  }
                }));
      },
    );
  }
}
