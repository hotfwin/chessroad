import 'cc-base.dart';

// 用车、马、相、士、将、炮、兵的英文单词首字母表示对应的棋子。有一个例外，那就是代表「马」的单词 Knight 和代表「将」的单词 King 都是以 'K' 开头，所以约定了用 'N' 或 'n' 来代表「马」，'K'或'k'代表「将」或「帅」。
// 此外，棋软开发者还约定，黑棋用小写字母表示，红棋用对应的大写字母表示。
// 这样一来，棋盘上 10 横 9 纵共 90 个交叉点，我们就可以用一个数组来表示棋盘上的棋子分布了。
// 「棋子分布」加上「当前轮谁走棋」两个信息，共同构成了一个象棋的「局面」信息
class Phase {
  String _side; //当前行棋方

  // 中国象棋的棋子放在纵线交叉点上，棋盘上总共有10行9列的交叉点位，一共90个位置
  List<String> _pieces; // 10行9列

  get side => _side;

  trunSide() => _side = Side.oppo(side); //交换下棋方

  String pieceAt(int index) => _pieces[index]; //查询10行9列的某个位置上的棋子

  Phase.defaultPhase() { 
    //
    _side = Side.Red;
    _pieces = List<String>(90);

    // 从上到下，棋盘第一行
    _pieces[0 * 9 + 0] = Piece.BlackRook;
    _pieces[0 * 9 + 1] = Piece.BlackKnight;
    _pieces[0 * 9 + 2] = Piece.BlackBishop;
    _pieces[0 * 9 + 3] = Piece.BlackAdvisor;
    _pieces[0 * 9 + 4] = Piece.BlackKing;
    _pieces[0 * 9 + 5] = Piece.BlackAdvisor;
    _pieces[0 * 9 + 6] = Piece.BlackBishop;
    _pieces[0 * 9 + 7] = Piece.BlackKnight;
    _pieces[0 * 9 + 8] = Piece.BlackRook;

    // 从上到下，棋盘第三行
    _pieces[2 * 9 + 1] = Piece.BlackCanon;
    _pieces[2 * 9 + 7] = Piece.BlackCanon;

    // 从上到下，棋盘第四行
    _pieces[3 * 9 + 0] = Piece.BlackPawn;
    _pieces[3 * 9 + 2] = Piece.BlackPawn;
    _pieces[3 * 9 + 4] = Piece.BlackPawn;
    _pieces[3 * 9 + 6] = Piece.BlackPawn;
    _pieces[3 * 9 + 8] = Piece.BlackPawn;

    // 从上到下，棋盘第十行
    _pieces[9 * 9 + 0] = Piece.RedRook;
    _pieces[9 * 9 + 1] = Piece.RedKnight;
    _pieces[9 * 9 + 2] = Piece.RedBishop;
    _pieces[9 * 9 + 3] = Piece.RedAdvisor;
    _pieces[9 * 9 + 4] = Piece.RedKing;
    _pieces[9 * 9 + 5] = Piece.RedAdvisor;
    _pieces[9 * 9 + 6] = Piece.RedBishop;
    _pieces[9 * 9 + 7] = Piece.RedKnight;
    _pieces[9 * 9 + 8] = Piece.RedRook;

    // 从上到下，棋盘第八行
    _pieces[7 * 9 + 1] = Piece.RedCanon;
    _pieces[7 * 9 + 7] = Piece.RedCanon;

    // 从上到下，棋盘第七行
    _pieces[6 * 9 + 0] = Piece.RedPawn;
    _pieces[6 * 9 + 2] = Piece.RedPawn;
    _pieces[6 * 9 + 4] = Piece.RedPawn;
    _pieces[6 * 9 + 6] = Piece.RedPawn;
    _pieces[6 * 9 + 8] = Piece.RedPawn;

    // 其它位置全部填空
    for (var i = 0; i < 90; i++) {
      _pieces[i] ??= Piece.Empty;
    }
  } 

  /// 验证移动棋子的着法是否合法
  bool validateMove(int from, int to) {
    // TODO:
    return true;
  }

  bool move(int from, int to) {
    //
    if (!validateMove(from, to)) return false;

    // 修改棋盘
    _pieces[to] = _pieces[from];
    _pieces[from] = Piece.Empty;

    // 交换走棋方
    // _side = Side.oppo(_side);

    return true;
  }


}
