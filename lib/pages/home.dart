// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:game1/controller/home_control.dart';
import 'package:image/image.dart' as imglib;

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var r = 1;
  var t = 1;
  var b = 1;

  late AnimationController control;
  late Animation anim;
  var co = GlobalKey();
  var basic_control = Home_Control(size: Size(50, 10));
  var best_size = MediaQueryData.fromWindow(window).size;
  var img =
      "https://www.perma-horti.com/wp-content/uploads/2019/02/image-2.jpg";
  var img_bytes;

  @override
  initState() {
    basic_control =
        Home_Control(size: Size(best_size.width - 40, best_size.width - 40));
    control =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    anim = Tween<double>(begin: 0, end: 150).animate(control);
    super.initState();
    load();

    // control.forward();
  }

  load() async {
    final ByteData imageData = await NetworkAssetBundle(Uri.parse(
            "https://deep-image.ai/assets/image-remove-bg.2235d8e3.webp"))
        .load("");
    final Uint8List bytes = imageData.buffer.asUint8List();
    img_bytes = bytes;
    var v = imglib.decodePng(
        List.from(List.generate(bytes.length, (index) => bytes[index])));
    print(img_bytes);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) => basic_control,
      child: Consumer<Home_Control>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(title: Text(model.tet)),
          backgroundColor: Colors.grey.shade500,
          body: Container(
            color: model.is_win
                ? Colors.black.withOpacity(.38)
                : Colors.transparent,
            child: Center(
              child: Container(
                height: w - 40,
                width: w - 40,
                color: Colors.grey.shade500,
                margin: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Stack(
                      children:
                          model.base_list.map((e) => e.get_wid()).toList(),
                    ),
                    Visibility(
                      visible: model.is_win,
                      child: Container(
                        height: h,
                        width: w,
                        color: Colors.black.withOpacity(.38),
                      ),
                    ),
                    Visibility(
                      visible: model.is_win,
                      child: AnimatedOpacity(
                        opacity: model.anim_opa,
                        duration: model.dur,
                        child: AnimatedScale(
                            scale: model.anim_opa,
                            duration: model.dur,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "You are the Winner",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white, elevation: 3),
                                  onPressed: () {
                                    model.reFresher();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Play again",
                                        style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.refresh,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              model.reFresher();
              print(model.is_running = false);
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class Contain {
  String s;
  double t;
  double l;
  Size size;
  Home_Control model;
  bool? isEmpty = false;
  Contain(
      {Key? key,
      required this.s,
      required this.t,
      required this.l,
      required this.size,
      required this.model,
      this.isEmpty});

  Widget get_wid() => isEmpty == true
      ? SizedBox(
          height: size.height / 4,
          width: size.height / 4,
        )
      : GestureDetector(
          onTap: () async {
            await model.changer(this);
          },
          child: AnimatedContainer(
            padding: EdgeInsets.all(1),
            duration: Duration(milliseconds: model.card_dur),
            height: size.height / 4,
            width: size.width / 4,
            margin: EdgeInsets.only(top: t, left: l),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child:
                  Text(s, style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
        );

  @override
  bool operator ==(Object other) {
    return other is Contain &&
        other.t == t &&
        other.l == l &&
        other.size == size &&
        other.isEmpty == isEmpty;
  }

  @override
  int get hashCode {
    return t.hashCode ^ l.hashCode ^ size.hashCode ^ isEmpty.hashCode;
  }
}
