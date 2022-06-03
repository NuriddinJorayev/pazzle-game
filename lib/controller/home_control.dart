// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'package:game1/pages/home.dart';

class Home_Control extends ChangeNotifier {
  var tet = "nurik";
  Size size;
  bool is_running = false;
  bool is_win = false;
  var card_dur = 280;
  var anim_opa = 1.0;
  var dur = Duration(milliseconds: 400);

  var base_list = <Contain>[];
  var coor = <List<int>>[
    <int>[1, 2, 3, 4],
    <int>[5, 6, 7, 8],
    <int>[9, 10, 11, 12],
    <int>[13, 14, 15, 0]
  ];
  var offset_list = <List<Offset>>[];
  Home_Control({required this.size}) {
    final double h = size.height;
    final double w = size.width;
    var fi = w * .25;
    var dun = w * .50;
    var duf = w * .75;

    offset_list.addAll([
      [of(0, 0), of(0, fi), of(0, dun), of(0, duf)],
      [of(fi, 0), of(fi, fi), of(fi, dun), of(fi, duf)],
      [of(dun, 0), of(dun, fi), of(dun, dun), of(dun, duf)],
      [of(duf, 0), of(duf, fi), of(duf, dun), of(duf, duf)],
    ]);
    list_filler();
  }

  winer() {
    anim_opa = 1;
    is_win = false;
    notifyListeners();
  }

  list_filler() {
    for (var i = 0; i < offset_list.length; i++) {
      var temp = <Contain>[];

      for (var j = 0; j < offset_list[i].length; j++) {
        if (coor[i][j] == 0) {
          temp.add(Contain(
              s: coor[i][j].toString(),
              t: offset_list[i][j].dx,
              l: offset_list[i][j].dy,
              size: this.size,
              isEmpty: true,
              model: this));
        } else {
          temp.add(Contain(
              s: coor[i][j].toString(),
              t: offset_list[i][j].dx,
              l: offset_list[i][j].dy,
              size: this.size,
              model: this));
        }
      }
      base_list.addAll(temp);
      temp = [];
    }
    notifyListeners();
  }

  Future changer(Contain contain) async {
    var cor = find_empty_card();
    var zero_coor = value_index_finder(0);
    var select_oder = coor_to_oder(contain);
    var selected_cor = value_index_finder(select_oder);
    if (!is_walk(selected_cor.first, selected_cor.last)) {
      return null;
    }
    if (is_running) {
      card_dur = 0;
      notifyListeners();
    }
    is_running = true;
    notifyListeners();
    var empty_oder = empty_card_oder(cor.first, cor.last); // int

    if (selected_cor.isEmpty) {
      print("error");
      print(select_oder);
      return null;
    }
    contain.t = offset_list[cor.first][cor.last].dx;
    contain.l = offset_list[cor.first][cor.last].dy;
    var t = coor[zero_coor.first][zero_coor.last];
    coor[zero_coor.first][zero_coor.last] =
        coor[selected_cor.first][selected_cor.last];
    coor[selected_cor.first][selected_cor.last] = t;
    is_win = isWin();
    notifyListeners();
    await Future.delayed(Duration(milliseconds: card_dur));
    base_list = [];
    list_filler();
    is_running = false;
    card_dur = 300;
    notifyListeners();
    for (var e in coor) {
      print(e);
    }

    print("------------------------------------");
  }

  List<int> find_card(Contain contain) {
    for (var e in base_list) {
      if (e == contain) {
        for (var i = 0; i < offset_list.length; i++) {
          for (var j = 0; j < offset_list[i].length; j++) {
            if (e.t == offset_list[i][j].dx && e.l == offset_list[i][j].dy) {
              return [i, j];
            }
          }
        }
      }
    }
    return [];
  }

  int empty_card_oder(int ii, int jj) {
    int temp = 0;
    for (var i = 0; i < coor.length; i++) {
      for (var j = 0; j < coor[i].length; j++) {
        temp++;
        if (i == ii && j == jj) {
          return temp;
        }
      }
    }
    return -1;
  }

  List<int> value_index_finder(int val) {
    var t = 0;
    for (var i = 0; i < coor.length; i++) {
      for (var j = 0; j < coor[i].length; j++) {
        t++;
        if (coor[i][j] == val) {
          return [i, j];
        }
      }
    }
    return [];
  }

  List<int> find_empty_card() {
    for (var i = 0; i < coor.length; i++) {
      for (var j = 0; j < coor[i].length; j++) {
        if (coor[i][j] == 0) {
          return [i, j];
        }
      }
    }
    return [];
  }

  int coor_to_oder(Contain con) {
    int temp = 0;
    for (var e in base_list) {
      temp++;
      if (e == con) {
        break;
      }
    }
    var t = 0;
    for (var e in coor) {
      for (var r in e) {
        t++;
        if (temp == t) {
          return r;
        }
      }
    }
    return -1;
  }

  Offset of(var i, var b) {
    return Offset(i.toDouble(), b.toDouble());
  }

  bool is_walk(int i, int j) {
    print("ok");
    var x = value_index_finder(0).first;
    var y = value_index_finder(0).last;
    if (i > -1 && i < 4 && j > -1 && j < 4) {
      if ((i == x - 1 && j == y) ||
          (i == x + 1 && j == y) ||
          (i == x && j == y + 1) ||
          (i == x && j == y - 1)) return true;
    }
    return false;
  }

  bool isWin() {
    var c = <List<int>>[
      <int>[1, 2, 3, 4],
      <int>[5, 6, 7, 8],
      <int>[9, 10, 11, 12],
      <int>[13, 14, 15, 0]
    ];
    for (var i = 0; i < coor.length; i++) {
      for (var j = 0; j < coor[i].length; j++) {
        if (coor[i][j] == c[i][j]) {
        } else {
          return false;
        }
      }
    }
    return true;
  }

  reFresher() async {
    is_win = false;
    anim_opa = 0.0;
    notifyListeners();

    coor.shuffle();
    for (var e in coor) {
      e.shuffle();
    }
    print(coor.first.first);
    for (var e in base_list) {
      e.t = offset_list[0][0].dx;
      e.l = offset_list[0][0].dy;
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 40));
    }
    // notifyListeners();

    await Future.delayed(Duration(seconds: 1));

    var tt = 0;
    var ran = [0, 1, 2, 3];
    var ran1 = [1, 0, 3, 2];

    ran.shuffle();
    ran1.shuffle();

    for (var i = 0; i < coor.length; i++) {
      for (var j = 0; j < coor[ran[i]].length; j++) {
        tt++;
        var x = value_index_finder(coor[ran[i]][ran1[j]]).first;
        var y = value_index_finder(coor[ran[i]][ran1[j]]).last;
        // print(value_index_finder(r).toString());
        base_list[tt - 1].t = offset_list[x][y].dx;
        base_list[tt - 1].l = offset_list[x][y].dy;
        base_list[tt - 1].s = coor[ran[i]][ran1[j]].toString();
        base_list[tt - 1].isEmpty = coor[ran[i]][ran1[j]] == 0;
        notifyListeners();
        await Future.delayed(Duration(milliseconds: 70));
      }
    }

    // base_list = [];
    // list_filler();

    print("object");
    for (var e in coor) {
      print(e);
    }
  }

  print_for_test(String s) {}
}
