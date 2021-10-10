import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:two_zero_four_eight/di/locator.dart';
import 'package:two_zero_four_eight/helpers/shared_preferences.dart';

import 'package:two_zero_four_eight/model/individual_cell.dart';
import 'package:two_zero_four_eight/themes/color.dart';

/// Size of the game borad is by defULT 4x4
const matrixSize = 4;

/// Max Random number to be generated
const maxValue = 100;

/// Value Decideder
const decider = 50;

/// Stored string for Highscore
const highScore = 'high_score';

/// Stored string for Current score
const currentScore = 'current_score';

///Cubit
class GameState extends Equatable {
  ///Constructor
  const GameState(
      {required this.currentGrid,
      this.currentScore = 0,
      this.highScore = 0,
      this.isGameOver = false,
      this.isGameWon = false});

  ///Game Grid
  final List<List<IndividualCell>> currentGrid;

  ///Total points
  final int currentScore;

  ///Total points
  final int highScore;

  ///IsGame won
  final bool isGameWon;

  ///IsGame over
  final bool isGameOver;
  @override
  List<Object?> get props => [currentGrid, currentScore, isGameWon, isGameOver];

  ///Update new values
  GameState copyWith({
    List<List<IndividualCell>>? currentGrid,
    int? currentScore,
    int? highScore,
    bool? isGameOver,
    bool? isGameWon,
  }) {
    return GameState(
      currentGrid: currentGrid ?? this.currentGrid,
      currentScore: currentScore ?? this.currentScore,
      highScore: highScore ?? this.highScore,
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
  //var _backupGrid = [<IndividualCell>[]];
  var _flatList = <IndividualCell>[];
  var _randomCell = -1;
  late IndividualCell _cellData;

  // void _copyGrid() {
  //   _backupGrid = List.generate(
  //       matrixSize,
  //       (i) => List.generate(
  //           matrixSize,
  //           (j) => IndividualCell(
  //               x: i,
  //               y: j,
  //               color: Color(ColorConstants.emptyGridBackground),
  //               fontSize: 15.0.sp)));
  // }

  void _flipGrid() {
    _currentGrid = _currentGrid.map((row) => row.reversed.toList()).toList();
    //print(_currentGrid);
    // for (var i = 0; i < matrixSize; i++) {
    //   final _row = _currentGrid[i];
    //   _currentGrid[i] = _row.reversed.toList();
    // }
  }

  void _transposeGrid(List<List<IndividualCell>> grid) {
    //New empty grid in _currentGrid
    _generateGrid(isHardRefresh: true);
    for (var i = 0; i < matrixSize; i++) {
      for (var j = 0; j < matrixSize; j++) {
        _currentGrid[i][j] = grid[j][i];
      }
    }
  }

  void _gameAlgorithm() {
    //_copyGrid();
    _currentGrid = _currentGrid
        .map(_filter)
        .toList()
        .map(_slide)
        .toList()
        .map(_reduce)
        .toList()
        .map(_filter)
        .toList()
        .map(_slide)
        .toList();
    _generateGrid();
    _generateNewNumber();
  }

  ///on left swipe
  void onLeft() {
    _gameAlgorithm();
    _emitCurrentGrid();
    _emitScores();
  }

  ///on right swipe
  void onRight() {
    _flipGrid();
    _gameAlgorithm();
    _flipGrid();
    _emitCurrentGrid();
    _emitScores();
  }

  ///on up swipe
  void onUp() {
    _transposeGrid(state.currentGrid);
    _flipGrid();
    _gameAlgorithm();
    _flipGrid();
    _transposeGrid(_currentGrid);
    _emitCurrentGrid();
    _emitScores();
  }

  ///on down swipe
  void onDown() {
    _transposeGrid(state.currentGrid);
    _gameAlgorithm();
    _transposeGrid(_currentGrid);
    _emitCurrentGrid();
    _emitScores();
  }

  ///Initialize Grid
  void initializeGrid() {
    _initialize();
    emit(state.copyWith(currentGrid: _currentGrid));
  }

  Future<void> _initialize() async {
    _generateGrid();
    _generateNewNumber();
    _generateNewNumber();
  }

  void _generateNewNumber() {
    _flattenList();
    if (_flatList.isEmpty) {
      _isGameWon();
      return;
    } else {
      _pickRandomIndex();
      _generateCellData();
      _generateRandomValue();
    }
  }

  void _isGameWon() {
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) {
        if (_currentGrid[i][j].value == 0) {
          return;
        }
        if (i != 3 &&
            _currentGrid[i][j].value == _currentGrid[i + 1][j].value) {
          return;
        }
        if (j != 3 &&
            _currentGrid[i][j].value == _currentGrid[i][j + 1].value) {
          return;
        }
      }
    }
    emit(state.copyWith(isGameOver: true));
  }

  void _generateGrid({bool isHardRefresh = false}) =>
      _currentGrid = List.generate(
          matrixSize,
          (i) => List.generate(
              matrixSize,
              (j) => IndividualCell(
                  x: i,
                  y: j,
                  value: isHardRefresh
                      ? 0
                      : _currentGrid.length > 1
                          ? _currentGrid[i][j].value
                          : 0,
                  tileColor: _getCellColor(isHardRefresh
                      ? 0
                      : _currentGrid.length > 1
                          ? _currentGrid[i][j].value
                          : 0),
                  fontSize: _getFontSize(isHardRefresh
                      ? 0
                      : _currentGrid.length > 1
                          ? _currentGrid[i][j].value
                          : 0),
                  fontColor: _getFontColor(isHardRefresh
                      ? 0
                      : _currentGrid.length > 1
                          ? _currentGrid[i][j].value
                          : 0))));

  double _getFontSize(int cellData) {
    var _fontSize = 25.0.sp;

    switch (cellData) {
      case 16:
      case 32:
      case 64:
        _fontSize = 23.0.sp;
        break;
      case 128:
      case 256:
      case 512:
        _fontSize = 19.0.sp;
        break;
      case 1024:
      case 2048:
        _fontSize = 16.0.sp;
        break;
      case 2:
      case 4:
      case 8:
      default:
        break;
    }
    return _fontSize;
  }

  Color _getCellColor(int cellData) {
    var _color = Color(ColorConstants.emptyGridBackground);

    switch (cellData) {
      case 2:
      case 4:
        _color = Color(ColorConstants.gridColorTwoFour);
        break;
      case 8:
      case 64:
      case 256:
        _color = Color(ColorConstants.gridColorEightSixtyFourTwoFiftySix);
        break;
      case 128:
      case 512:
        _color = Color(ColorConstants.gridColorOneTwentyEightFiveOneTwo);
        break;
      case 16:
      case 32:
      case 1024:
        _color = Color(ColorConstants.gridColorSixteenThirtyTwoOneZeroTwoFour);
        break;
      case 2048:
        _color = Color(ColorConstants.gridColorWin);
        break;
      default:
        break;
    }
    return _color;
  }

  Color _getFontColor(int cellData) {
    var _color = Colors.black;

    switch (cellData) {
      case 2:
      case 4:
        _color = Color(ColorConstants.fontColorTwoFour);
        break;
      case 8:
      case 64:
      case 256:
        _color = Color(ColorConstants.gridColorTwoFour);
        break;
      case 128:
      case 512:
        _color = Color(ColorConstants.gridColorWin);
        break;
      case 16:
      case 32:
      case 1024:
        _color = Color(ColorConstants.gridColorEightSixtyFourTwoFiftySix);
        break;
      case 2048:
        _color = Color(ColorConstants.gridColorOneTwentyEightFiveOneTwo);
        break;
      default:
        break;
    }
    return _color;
  }

  void _flattenList() => _flatList = flatten(_currentGrid)
      .map((e) => e.value == 0 ? e : null)
      .whereNotNull()
      .toList();

  void _pickRandomIndex() => _randomCell = Random().nextInt(_flatList.length);

  void _generateCellData() => _cellData = _flatList[_randomCell];

  void _generateRandomValue() {
    final r = Random().nextInt(maxValue);
    _currentGrid[_cellData.x][_cellData.y].value = r > decider ? 4 : 2;
    _currentGrid[_cellData.x][_cellData.y].tileColor =
        Color(ColorConstants.gridColorTwoFour);
  }

  void _emitCurrentGrid() {
    emit(state.copyWith(currentGrid: _currentGrid));
  }

  void _emitScores() {
    final _pref = locator.get<SharedPreference>();
    final _highScore = _pref.sharedPreferences.getInt(highScore);
    final _currentScore = _pref.sharedPreferences.getInt(currentScore);
    emit(state.copyWith(highScore: _highScore, currentScore: _currentScore));
  }
}

/// Flatten a list
List<T> flatten<T>(Iterable<Iterable<T>> list) =>
    [for (var sublist in list) ...sublist];

List<IndividualCell> _filter(List<IndividualCell> row) =>
    row.where((element) => element.value != 0).toList();

List<IndividualCell> _slide(List<IndividualCell> row) =>
    List<IndividualCell>.filled(matrixSize - row.length, IndividualCell()) +
    row;

List<IndividualCell> _reduce(List<IndividualCell> row) {
  for (var i = matrixSize - 1; i >= 1; i--) {
    final _value = row[i].value;
    final _element = row[i - 1].value;
    if (_value == _element) {
      row[i].value = _value + _element;
      row[i - 1].value = 0;
      _storeScores(row[i].value);
    }
  }
  return row;
}

Future<void> _storeScores(final int value) async {
  final _pref = locator.get<SharedPreference>();
  await _setCurrentScore(score: value, pref: _pref);
  await _setHighScore(score: value, pref: _pref);
}

int _getHighScore(final SharedPreference pref) {
  return pref.sharedPreferences.getInt(highScore) ?? 0;
}

// int _getCurrentScore(final SharedPreference pref) {
//   return pref.sharedPreferences.getInt(currentScore) ?? 0;
// }

Future<void> _setHighScore(
    {required final int score, required final SharedPreference pref}) async {
  final _existingHighScore = _getHighScore(pref);
  if (score > _existingHighScore) {
    await pref.sharedPreferences.setInt(highScore, score);
  }
}

Future<void> _setCurrentScore(
    {required final int score, required final SharedPreference pref}) async {
  await pref.sharedPreferences.setInt(currentScore, score);
}
