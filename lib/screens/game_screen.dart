import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:two_zero_four_eight/cubit/game_cubit.dart';
import 'package:two_zero_four_eight/model/individual_cell.dart';
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
          style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(ColorConstants.gridBackground),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 25.0.w,
                height: 8.0.h,
                color: Color(ColorConstants.gridBackground),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Current Score',
                      style: TextStyle(fontSize: 6.0.sp),
                    ),
                    BlocSelector<GameCubit, GameState, int>(
                      selector: (state) => state.currentScore,
                      builder: (context, currentScore) => Dance(
                        key: ValueKey('$currentScore'),
                        child: Text(
                          currentScore.toString(),
                          style:
                              TextStyle(fontSize: 13.0.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 25.0.w,
                height: 8.0.h,
                color: Color(ColorConstants.gridBackground),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'High Score',
                      style: TextStyle(fontSize: 6.0.sp),
                    ),
                    BlocSelector<GameCubit, GameState, int>(
                      selector: (state) => state.highScore,
                      builder: (context, highScore) => Pulse(
                        key: ValueKey('$highScore'),
                        child: Text(
                          highScore.toString(),
                          style:
                              TextStyle(fontSize: 13.0.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: 100.0.w,
                  height: 91.0.w,
                  color: Color(ColorConstants.gridBackground),
                  margin: EdgeInsets.all(4.0.w),
                  padding: EdgeInsets.all(2.0.w),
                  child: BlocSelector<GameCubit, GameState,
                      List<List<IndividualCell>>>(
                    selector: (state) => state.currentGrid,
                    builder: (context, currentGrid) => GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      crossAxisSpacing: 0.5.w,
                      mainAxisSpacing: 0.5.w,
                      crossAxisCount: 4,
                      children: flatten(currentGrid)
                          .map((cell) => IndividualTile(
                              key: ValueKey('${cell.x}${cell.y}'), cell: cell))
                          .toList(),
                    ),
                  ),
                ),
                BlocSelector<GameCubit, GameState, bool>(
                  selector: (state) => state.isGameWon,
                  builder: (context, isGameWon) => Visibility(
                    visible: isGameWon,
                    child: Container(
                      width: 100.0.w,
                      height: 30.0.w,
                      margin: EdgeInsets.all(4.0.w),
                      padding: EdgeInsets.all(2.0.w),
                      color: const Color.fromRGBO(100, 100, 100, 0.5),
                      child: Center(
                        child: Roulette(
                          delay: const Duration(seconds: 1),
                          key: UniqueKey(),
                          child: Text(
                            '\u{1F600} You Won! \u{1F600}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 30.0.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                BlocSelector<GameCubit, GameState, bool>(
                  selector: (state) => state.isGameOver,
                  builder: (context, isGameOver) => Visibility(
                    visible: isGameOver,
                    child: Container(
                      width: 100.0.w,
                      height: 30.0.w,
                      margin: EdgeInsets.all(4.0.w),
                      padding: EdgeInsets.all(2.0.w),
                      color: const Color.fromRGBO(100, 100, 100, 0.5),
                      child: Center(
                        child: Flash(
                          key: UniqueKey(),
                          child: Text(
                            '\u{1F62D} You Lost! \u{1F62D}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 30.0.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onHorizontalDragEnd: (draggedDetails) {
              if (draggedDetails.primaryVelocity! > 0) {
                context.read<GameCubit>().onLeft();
              } else if (draggedDetails.primaryVelocity! < 0) {
                context.read<GameCubit>().onRight();
              }
            },
            onVerticalDragEnd: (draggedDetails) {
              if (draggedDetails.primaryVelocity! > 0) {
                context.read<GameCubit>().onDown();
              } else if (draggedDetails.primaryVelocity! < 0) {
                context.read<GameCubit>().onUp();
              }
            },
          ),
          SizedBox(
              height: 10.0.w,
              width: 30.0.w,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(ColorConstants.gridBackground))),
                onPressed: () {
                  context.read<GameCubit>().onReset();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.replay),
                    Text('Reset'),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
