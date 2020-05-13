import 'package:flutter/material.dart';

import '../common/color-consts.dart';
import 'board-painter.dart';
import 'words-on-board.dart';
import 'pieces-painter.dart';
import '../game/battle.dart';

//画棋盘背景颜色
class BoardWidget extends StatelessWidget {
  // 棋盘内边界 + 棋盘上的路数指定文字高度
  static const Padding = 5.0, DigitsHeight = 36.0;

  // 棋盘的宽高
  final double width, height;

  // 棋盘的点击事件回调，由 board widget 的创建者传入
  final Function(BuildContext, int) onBoardTap;

  // 由于横盘上的小格子都是正方形，因素宽度确定后，棋盘的高度也就确定了
  BoardWidget({@required this.width, @required this.onBoardTap})
      : height = (width - Padding * 2) / 9 * 10 + (Padding + DigitsHeight) * 2;

  @override
  Widget build(BuildContext context) {
    final boardContainer = Container(
      width: width,
      height: height,
      // 棋盘的背景木纹颜色是通过给 Container 指定背景色和圆角实现的
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConsts.BoardBackground,
      ),
      child: CustomPaint(
        painter: BoardPainter(width: width), // 背景一层绘制横盘上的线格
        // 前景一层绘制棋子
        foregroundPainter: PiecesPainter(
          width: width,
          // phase: Phase.defaultPhase(),
          phase: Battle.shared.phase,    //棋子布局
          focusIndex: Battle.shared.focusIndex,
          blurIndex: Battle.shared.blurIndex,
        ),

        // CustomPaint 的 child 用于布置其上的子组件，这里放置是我们的「河界」、「路数」等文字信息
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: Padding,
            // 因为棋子是放在交叉线上的，不是放置在格子内，所以棋子左右各有一半在格线之外
            // 这里先依据横盘的宽度计算出一个格子的边长，再依此决定垂直方向的边距
            horizontal: (width - Padding * 2) / 9 / 2 +
                Padding -
                WordsOnBoard.DigitsFontSize / 2,
          ),
          child: WordsOnBoard(),
        ),
      ),
    );

    // 用 GestureDetector 组件包裹我们的 board 组件，用于检测 board 上的点击事件
    return GestureDetector(
      child: boardContainer,
      onTapUp: (d) {
        // print("(点击了棋盘)手势检测： ${d.localPosition}");

        final gridWidth = (width - Padding * 2) * 8 / 9; // 网格的总宽度
        final squareSide = gridWidth / 8; //每格的边长

        //点击：横坐标，纵坐标
        final dx = d.localPosition.dx, dy = d.localPosition.dy;

        // 棋盘上的行、列转换
        final row = (dy - Padding - DigitsHeight) ~/ squareSide; //棋盘行：（0-9）
        final colunm = (dx - Padding) ~/ squareSide; //棋盘列：（0-8） 对应(1-9:九 - 一)

        if (row < 0 || row > 9) {
          print('row棋盘外');
          return;
        }

        if (colunm < 0 || colunm > 8) {
          print('column在棋盘外');
          return;
        }

        print('棋盘里：row => $row, column=> $colunm ');

        //回调，给调用才处理棋盘的点击
        //「row * 9 + column」是棋盘位置表示的一个基本约定。它表示的意思是：
        // 从上到下、从左到右，第 row 行 column 列的棋子，
        // 在棋盘局面 Phase 类的棋子列表 List<String>(90) 中的存放索引值是 row * 9 + column。
        onBoardTap(context, row * 9 + colunm);
      },
    );
  }
}
