import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'routes/battle-page.dart';
import 'routes/main-menu.dart';

void main() {
  runApp(ChessRoadApp());

  // 仅支持竖屏
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  //全屏,不显示状态栏
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  SystemChrome.setEnabledSystemUIOverlays([]);
}

class ChessRoadApp extends StatelessWidget {
  static const StatusBarHeight = 28.0;
  const ChessRoadApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // primarySwatch: Colors.brown,
        primarySwatch: Colors.lime,
        fontFamily: 'QiTi', //全局字体
      ),
      debugShowCheckedModeBanner: false,
      // home: BattlePage(),
      home: MainMenu(),
    );
  }
}
