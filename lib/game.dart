import 'package:shared_preferences/shared_preferences.dart';

List operate(List<int> row,int score,SharedPreferences sharedPref){
  row = slide(row);
  List result = combine(row,score,sharedPref);
  int sc=result[0];
  row = result[1];
  row = slide(row);

  print('from func ${sc}');
  return [sc,row];
}

List<int> filter(List<int> row){
  List<int> temp = [];
  for(int i=0;i<row.length;i++){
    if(row[i] != 0){
      temp.add(row[i]);
    }
  }
  return temp;
}

List<int> slide(List<int> row){
  List<int> arr = filter(row);
  int missing = 4-arr.length;
  List<int> zeroes = zeroArray(missing);
  arr = zeroes + arr;
  return arr;
}

List<int> zeroArray(int length){
  List<int> zeroes = [];
  for(int i=0;i<length;i++){
    zeroes.add(0);
  }
  return zeroes;
}


List combine(List<int> row,int score,SharedPreferences sharedPref) {
  for (int i = 3; i >= 1; i--) {
    int a = row[i];
    int b = row[i - 1];
    if (a == b) {
      row[i] = a + b;
      score += row[i];
      int sc = sharedPref.getInt('high_score');
      if(sc == null){
        sharedPref.setInt('high_score', score);
      }else {
        if(score > sc) {
          sharedPref.setInt('high_score', score);
        }
      }
      row[i - 1] = 0;
     
    }
  }
  return [score,row];
}

bool isGameWon(List<List<int>> grid) {
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j] == 2048) {
        return true;
      }
    }
  }
  return false;
}


bool isGameOver(List<List<int>> grid) {
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j] == 0) {
        return false;
      }
      if (i != 3 && grid[i][j] == grid[i + 1][j]) {
        return false;
      }
      if (j != 3 && grid[i][j] == grid[i][j + 1]) {
        return false;
      }
    }
  }
  return true;
}