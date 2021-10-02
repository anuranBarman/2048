import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Cubit
class GameState extends Equatable {
  ///Constructor
  const GameState(
      {required this.currentGrid,
      this.score = 0,
      this.isGameOver = false,
      this.isGameWon = false});

  ///Game Grid
  final List<List<int>> currentGrid;

  ///Total points
  final int score;

  ///IsGame won
  final bool isGameWon;

  ///IsGame over
  final bool isGameOver;
  @override
  List<Object?> get props => [currentGrid, score, isGameWon, isGameOver];

  ///Update new values
  GameState copyWith({
    List<List<int>>? currentGrid,
    int? score,
    bool? isGameOver,
    bool? isGameWon,
  }) {
    return GameState(
      currentGrid: currentGrid ?? this.currentGrid,
      score: score ?? this.score,
      isGameWon: isGameWon ?? this.isGameWon,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}

///State
class GameCubit extends Cubit<GameState> {
  ///Constructor
  GameCubit({required List<List<int>> currentGrid})
      : super(GameState(currentGrid: currentGrid)) {
    emit(state);
  }

  ///copy grid
  void copyGrid() {}

  ///flip grid
  void flipGrid() {}

  ///transpose grid
  void transposeGrid() {}

  ///Add number
  void addNumber() {}

  ///on left swipe
  void onLeft() {}

  ///on right swipe
  void onRight() {}

  ///on up swipe
  void onUp() {}

  ///on down swipe
  void onDown() {}

  ///operate
  void operate() {}

  ///filter
  void filter() {}

  ///slide
  void slide() {}

  ///zero array
  void zeroArray() {}

  ///combine
  void combine() {}

  ///is Game won
  void isGameWon() {}

  ///is Game over
  void isGameOver() {}

  ///reset Gride
  void resetGrid() {}
}
