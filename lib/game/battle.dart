import '../cchess/phase.dart';
import '../cchess/cc-base.dart';

// Battle类集中管理棋盘上的棋子、对战结果、引擎调用等事务
class Battle {
  //
  static Battle _instance;

  Phase _phase;

  int _focusIndex, _blurIndex; //标记当前位置，和前一个位置

  static get shared {
    _instance ??= Battle();
    return _instance;
  }

  init() {
    _phase = Phase.defaultPhase();
    _focusIndex = _blurIndex = -1;
  }

  // 点击选中一个棋子，使用 _focusIndex 来标记此位置
  // 棋子绘制时，将在这个位置绘制棋子的选中效果
  select(int pos) {
    _focusIndex = pos;
    _blurIndex = -1;
    // _blurIndex = Move.InvalidIndex;

  }

  // 从 from 到 to 位置移动棋子，使用 _focusIndex 和 _blurIndex 来标记 from 和 to 位置
  // 棋子绘制时，将在这两个位置分别绘制棋子的移动前的位置和当前位置
  move(int from, int to) {
    if(!_phase.move(from, to)) return false;

    // 移动棋子时，更新这两个标志位置，然后的绘制会把它们展示在界面上
    _blurIndex = from;
    _focusIndex = to;

    return true;
  }

  // 清除棋子的选中和移动前的位置指示
  clear() {
    _blurIndex = _focusIndex = -1;
  }

  get phase => _phase;
  get focusIndex => _focusIndex;
  get blurIndex => _blurIndex;
}
