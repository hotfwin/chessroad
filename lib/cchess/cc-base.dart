//将与中国象棋逻辑相关的实现代码限制在此文件夹范围内

//代表棋盘两方
class Side {
  static const Unknown = '-';
  static const Red = 'w'; //中国象棋的一些理论基础来自于国际象棋
  /// 'W'是国际象棋中的whiter侧，在中国象棋中没有白方，代指红方。
  static const Black = 'b'; //表示转文

  static String of(String piece) {
    // 中国象棋用大写字母代表红方的棋子，用小定字母代码黑方的框
    // RNBAKCP 依次代码的棋子为：车马象仕将炮兵
    if ('RNBAKCP'.contains(piece)) return Red;
    if ('rnbakcp'.contains(piece)) return Black;
    return Unknown;
  }

  static bool sameSide(String p1, String p2) {
    return of(p1) == of(p2);
  }

  // 红黑双方交换
  static String oppo(String side) {
    if (side == Red) return Black;
    if (side == Black) return Red;
    return side;
  }
}

//棋盘中的棋子
class Piece {
  static const Empty = ' ';
  //
  static const RedRook='R';     //车
  static const RedKnight = 'N';  //「马」的单词 Knight 和代表「将」的单词 King 都是以 'K' 开头,约定了用 'N' 或 'n' 来代表「马」，'K'或'k'代表「将」或「帅」
  static const RedBishop = 'B';
  static const RedAdvisor = 'A';
  static const RedKing = 'K';
  static const RedCanon = 'C';
  static const RedPawn = 'P';
  //
  static const BlackRook = 'r';
  static const BlackKnight = 'n';
  static const BlackBishop = 'b';
  static const BlackAdvisor = 'a';
  static const BlackKing = 'k';
  static const BlackCanon = 'c';
  static const BlackPawn = 'p';

  static const Names={
    Empty: '',
    //
    RedRook:'车',
    RedKnight: '马',
    RedBishop: '相',
    RedAdvisor: '仕',
    RedKing: '帅',
    RedCanon: '炮',
    RedPawn: '兵',
    //
    BlackRook: '车',
    BlackKnight: '马',
    BlackBishop: '象',
    BlackAdvisor: '士',
    BlackKing: '将',
    BlackCanon: '炮',
    BlackPawn: '卒',

  };

  static bool isRed(String c) => 'RNBAKCP'.contains(c);   //是否为红方
  static bool isBlack(String c) => 'rnbakcp'.contains(c);  //是否为黑方
}
