import 'package:flutter/material.dart';
import '../board/board-widget.dart';
import '../game/battle.dart';
import '../cchess/cc-base.dart';

class BattlePage extends StatefulWidget {
  static const BoardMarginV = 10.0, BoardMarginH = 10.0; //棋盘的纵横方向的边距

  const BattlePage({Key key}) : super(key: key);

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  // 由 BattlePage 的 State 类来处理棋盘的点击事件
  onBoardTap(BuildContext context, int index) {
    //
    print('处理棋盘点击事件-board cross index: $index');

    final phase = Battle.shared.phase;

    // 仅 Phase 中的 side 指示一方能动棋 ,暂时只能动红方
    if (phase.side != Side.Red) {
      print('暂时只能移动红方的棋子');
      return;
    }

    final tapedPiece = phase.pieceAt(index);

    // 之前已经有棋子被选中了,并且是 红方,能动的
    if (Battle.shared.focusIndex != -1 &&
        Side.of(phase.pieceAt(Battle.shared.focusIndex)) == Side.Red) {
      //
      // 当前点击的棋子和之前已经选择的是同一个位置
      if (Battle.shared.focusIndex == index) return;

      // 之前已经选择的棋子和现在点击的棋子是同一边的，说明是选择另外一个棋子
      final focusPiece = phase.pieceAt(Battle.shared.focusIndex);

      if (Side.sameSide(focusPiece, tapedPiece)) {
        print('之前选择过棋子,现在选择了新的棋子');
        Battle.shared.select(index);
        //
      } else if (Battle.shared.move(Battle.shared.focusIndex, index)) {
        print('现在点击的棋子和上一次选择棋子不同边，要么是吃子，要么是移动棋子到空白处');
        // todo: scan game result
      }
      //
    } else {
      // 之前未选择棋子，现在点击就是选择棋子
      print('之前未选择棋子，现在点击就是选择棋子');
      if (tapedPiece != Piece.Empty) Battle.shared.select(index);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 使用默认的「新对局」棋子分布
    Battle.shared.init();
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size; //窗口尺寸
    final boardWidth = windowSize.width - BattlePage.BoardMarginV * 2;

    return Scaffold(
      appBar: AppBar(title: Text('中国象棋99')),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: BattlePage.BoardMarginH,
          vertical: BattlePage.BoardMarginV,
        ),
        child: BoardWidget(
          width: boardWidth,
          onBoardTap: onBoardTap,
        ),
      ),
    );
  }
}
