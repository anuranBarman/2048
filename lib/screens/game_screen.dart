import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:two_zero_four_eight/cubit/game_cubit.dart';
import 'package:two_zero_four_eight/themes/color.dart';
import 'package:two_zero_four_eight/widgets/individual_tile.dart';

/// Sensitivity
const sensitivity = 8;

///Game Home screen
class GameScreen extends StatefulWidget {
  ///Constructor
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GameCubit>(context).initializeGrid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '2048',
          style: TextStyle(fontSize: 25.0.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(ColorConstants.gridBackground),
      ),
      body: BlocConsumer<GameCubit, GameState>(
        listener: (context, state) {},
        builder: (context, state) {
          return GestureDetector(
            child: Center(
                child: Container(
              width: 100.0.w,
              height: 91.0.w,
              color: Color(ColorConstants.gridBackground),
              margin: EdgeInsets.all(4.0.w),
              padding: EdgeInsets.all(2.0.w),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                crossAxisSpacing: 0.5.w,
                mainAxisSpacing: 0.5.w,
                crossAxisCount: 4,
                children: flatten(state.currentGrid)
                    .map((cell) => IndividualTile(
                        key: ValueKey('${cell.x}${cell.y}'), cell: cell))
                    .toList(),
              ),
            )),
            onHorizontalDragEnd: (draggedDetails) {
              if (draggedDetails.primaryVelocity! > 0) {
                context.read<GameCubit>().onLeft();
              } else if (draggedDetails.primaryVelocity! < 0) {
                context.read<GameCubit>().onRight();
              }
            },
            onVerticalDragEnd: (draggedDetails) {
              if (draggedDetails.primaryVelocity! > 0) {
                context.read<GameCubit>().onUp();
              } else if (draggedDetails.primaryVelocity! < 0) {
                context.read<GameCubit>().onDown();
              }
            },
          );
        },
      ),
    );
  }
}
