import 'package:flutter/material.dart';
import '../cchess/cc-base.dart';
import '../game/battle.dart';
import '../board/board-widget.dart';

///测试中国名模
class BattlePage extends StatefulWidget {
  //棋盘纵横方向的边距
  static const BoardMarginV = 10.0, BoardMarginH = 8.0; //棋盘：上边距为10,左右边距为8.

  const BattlePage({Key key}) : super(key: key);

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  // 由 BattlePage 的 State 类来处理棋盘的点击事件
  onBoardTap(BuildContext context, int index) {
    //
    print('处理点击事件：board cross index: $index');

    final phase = Battle.shared.phase;
    // print('是哪一方呀:${phase.side}');

    // 仅 Phase 中的 side 指示一方能动棋
    if (phase.side != Side.Red) {
      print('只能移动自己的（红方）:my=>${phase.side}  side=>${Side.Red}');
      return;
    }

    final tapedPiece = phase.pieceAt(index);

    // 之前已经有棋子被选中了
    if (Battle.shared.focusIndex != -1 &&
        Side.of(phase.pieceAt(Battle.shared.focusIndex)) == Side.Red) {
      //当前点击的棋子和之前已经经选择的是同一个位置
      if (Battle.shared.focusIndex == index) {
        print('点击了已选择的棋子');
        return;
      }

      //之前已经选择的棋子和现在点击 的棋子是同一边的，说明是选择了另外的一个棋子
      final focusPiece = phase.pieceAt(Battle.shared.focusIndex);

      if (Side.sameSide(focusPiece, tapedPiece)) {
        Battle.shared.select(index);
      } else if (Battle.shared.move(Battle.shared.focusIndex, index)) {
        //
        print('现在点击的棋子和上一次选择的棋子不同边，要么是吃子，要么是移动棋子到空白处。');
      }
    } else {
      //之前未选择棋子，现在点击就是选择棋子
      print('选择棋子');
      if (tapedPiece != Piece.Empty) Battle.shared.select(index);
    }

    //重新绘制
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //使用默认的“新对局”棋子分布
    Battle.shared.init();
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size; //查询了窗口的尺寸(宽)
    final boardHeight = windowSize.width - BattlePage.BoardMarginH * 2; //高

    return Scaffold(
      appBar: AppBar(
        title: Text("中国象棋-Battle"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: BattlePage.BoardMarginH, //左边距为8
          vertical: BattlePage.BoardMarginV, //上边距为10
        ),
        child: BoardWidget(
          width: boardHeight,
          onBoardTap: onBoardTap,
        ), // 在 BoardWidget 的创建过程中传入棋盘点击事件的回调方法
      ),
    );
  }
}
