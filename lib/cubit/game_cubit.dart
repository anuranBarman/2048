import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:two_zero_four_eight/model/individual_cell.dart';
import 'package:two_zero_four_eight/themes/color.dart';

/// Size of the game borad is by defULT 4x4
const matrixSize = 4;

/// Max Random number to be generated
const maxValue = 100;

/// Value Decideder
const decider = 50;

///Cubit
class GameState extends Equatable {
  ///Constructor
  const GameState(
      {required this.currentGrid,
      this.score = 0,
      this.isGameOver = false,
      this.isGameWon = false});

  ///Game Grid
  final List<List<IndividualCell>> currentGrid;

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
    List<List<IndividualCell>>? currentGrid,
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
  GameCubit({required List<List<IndividualCell>> currentGrid})
      : super(GameState(currentGrid: currentGrid)) {
    emit(state);
  }

  var _currentGrid = [<IndividualCell>[]];
  var _flatList = <IndividualCell>[];
  var _randomCell = -1;
  late IndividualCell _cellData;

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

  ///Initialize Grid
  void initializeGrid() {
    _initialize();
    emit(state.copyWith(currentGrid: _currentGrid));
  }

  void _initialize() {
    _generateGrid();
    _initActions();
    _initActions();
  }

  void _initActions() {
    _flattenList();
    _pickRandomIndex();
    _generateCellData();
    _generateRandomValue();
  }

  void _generateGrid() => _currentGrid = List.generate(
      matrixSize,
      (i) => List.generate(
          matrixSize,
          (j) => IndividualCell(
              x: i,
              y: j,
              color: Color(ColorConstants.emptyGridBackground),
              fontSize: 15.0.sp)));

  void _flattenList() => _flatList = flatten(_currentGrid)
      .map((e) => e.value == 0 ? e : null)
      .whereNotNull()
      .toList();

  void _pickRandomIndex() => _randomCell = Random().nextInt(_flatList.length);

  void _generateCellData() => _cellData = _flatList[_randomCell];

  void _generateRandomValue() {
    final r = Random().nextInt(maxValue);
    _currentGrid[_cellData.x][_cellData.y].value = r > decider ? 4 : 2;
    _currentGrid[_cellData.x][_cellData.y].color =
        Color(ColorConstants.gridColorTwoFour);
  }
}

/// Flatten a list
List<T> flatten<T>(Iterable<Iterable<T>> list) =>
    [for (var sublist in list) ...sublist];
