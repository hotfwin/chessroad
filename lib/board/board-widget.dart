import 'package:flutter/material.dart';
import '../common/color-consts.dart';
import 'board-painter.dart';
import 'words-on-board.dart';
import 'pieces-painter.dart';
import '../cchess/phase.dart';

//画棋盘背景颜色
class BoardWidget extends StatelessWidget {
  // 棋盘内边界 + 棋盘上的路数指定文字高度
  static const Padding = 5.0, DigitsHeight = 36.0;

  // 棋盘的宽高
  final double width, height;

  // 由于横盘上的小格子都是正方形，因素宽度确定后，棋盘的高度也就确定了
  BoardWidget({@required this.width})
      : height = (width - Padding * 2) / 9 * 10 + (Padding + DigitsHeight) * 2;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          phase: Phase.defaultPhase(),
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
  }
}
