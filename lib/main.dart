import 'package:flutter/material.dart';
import 'routes/battle-page.dart';

void main() => runApp(ChessRoadApp());

class ChessRoadApp extends StatelessWidget {
  const ChessRoadApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.brown),
      debugShowCheckedModeBanner: false,
      home: BattlePage(),
    );
  }
}
