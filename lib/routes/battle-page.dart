import 'package:flutter/material.dart';
import '../board/board-widget.dart';
import '../game/battle.dart';
import '../cchess/cc-base.dart';
import '../common/color-consts.dart';
import '../main.dart';
import '../engine/cloud-engine.dart';

class BattlePage extends StatefulWidget {
  // static const BoardMarginV = 10.0, BoardMarginH = 10.0; //棋盘的纵横方向的边距
  static double boardMargin = 10.0, screenPaddingH = 10.0; //棋盘的纵横方向的边距

  const BattlePage({Key key}) : super(key: key);

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  String _status = ''; //对战后台的状态
  changeStatus(String status) => setState(() => _status = status);

  void calcScreenPaddingH() {
    //
    // 当屏幕的纵横比小于16/9时，限制棋盘的宽度
    final windowSize = MediaQuery.of(context).size;
    double height = windowSize.height, width = windowSize.width;

    if (height / width < 16.0 / 9.0) {
      width = height * 9 / 16;
      // 横盘宽度之外的空间，分左右两边，由 screenPaddingH 来持有，布局时添加到 BoardWidget 外围水平边距
      BattlePage.screenPaddingH =
          (windowSize.width - width) / 2 - BattlePage.boardMargin;
    }
  }

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
        final result = Battle.shared.scanBattleResult();

        switch (result) {
          case BattleResult.Pending:
            // 玩家走一步棋后，如果游戏还没有结束，则启动引擎走棋
            engineToGo();
            break;
          case BattleResult.Win:
            break;
          case BattleResult.Lose:
            break;
          case BattleResult.Draw:
            break;
        }
        
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

  //标题、活动状态、顶部按钮等
  Widget createPageHeader() {
    //
    final titleStyle =
        TextStyle(fontSize: 28, color: ColorConsts.DarkTextPrimary);
    final subTitleStyle =
        TextStyle(fontSize: 16, color: ColorConsts.DarkTextSecondary);

    return Container(
      margin: EdgeInsets.only(top: ChessRoadApp.StatusBarHeight),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorConsts.DarkTextPrimary,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); //返回上一页
                },
              ),
              Expanded(child: SizedBox()),
              Text('单机对战', style: titleStyle),
              Expanded(child: SizedBox()),
              IconButton(
                icon: Icon(Icons.settings, color: ColorConsts.DarkTextPrimary),
                onPressed: () {},
              ),
            ],
          ),
          Container(
            height: 4,
            width: 180,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: ColorConsts.BoardBackground,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            // child: Text('[游戏状态]', maxLines: 1, style: subTitleStyle),
            child: Text(_status, maxLines: 1, style: subTitleStyle),
          ),
        ],
      ),
    );
  }

  Widget createBoard() {
    //
    // final windowSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: BattlePage.screenPaddingH,
        vertical: BattlePage.boardMargin,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConsts.BoardBackground,
      ),
      child: BoardWidget(
        // 棋盘的宽度已经扣除了部分边界
        // width: windowSize.width - BattlePage.BoardMarginH * 2,
        // 这里将 screenPaddingH 作为边距，放置在 BoardWidget 左右，这样棋盘将水平居中显示
        width:
            MediaQuery.of(context).size.width - BattlePage.screenPaddingH * 2,
        onBoardTap: onBoardTap,
      ),
    );
  }

  // 操作菜单栏
  Widget createOperatorBar() {
    //
    final buttonStyle = TextStyle(color: ColorConsts.Primary, fontSize: 20);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConsts.BoardBackground,
      ),
      margin: EdgeInsets.symmetric(horizontal: BattlePage.screenPaddingH),
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(children: <Widget>[
        Expanded(child: SizedBox()),
        FlatButton(child: Text('新对局', style: buttonStyle), onPressed: () {}),
        Expanded(child: SizedBox()),
        FlatButton(child: Text('悔棋', style: buttonStyle), onPressed: () {}),
        Expanded(child: SizedBox()),
        FlatButton(child: Text('分析局面', style: buttonStyle), onPressed: () {}),
        Expanded(child: SizedBox()),
      ]),
    );
  }

  // 对于底部的空间的弹性处理
  Widget buildFooter() {
    //
    final size = MediaQuery.of(context).size;

    final manualText = '<暂无棋谱>';

    if (size.height / size.width > 16 / 9) {
      // 长屏幕显示着法列表
      // print('长屏幕显示着法列表');
      return buildManualPanel(manualText);
    } else {
      // 短屏幕显示一个按钮，点击它后弹出着法列表
      // print('短屏幕显示一个按钮，点击它后弹出着法列表');
      return buildExpandableManaulPanel(manualText);
    }
  }

  // 长屏幕显示着法列表
  Widget buildManualPanel(String text) {
    //
    final manualStyle = TextStyle(
      fontSize: 18,
      color: ColorConsts.DarkTextSecondary,
      height: 1.5,
    );

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          child: Text(text, style: manualStyle),
        ),
      ),
    );
  }

  // 短屏幕显示一个按钮，点击它后弹出着法列表,  //这里有============bug======================
  Widget buildExpandableManaulPanel(String text) {
    //
    final manualStyle = TextStyle(fontSize: 18, height: 1.5);

    return Expanded(
      child: IconButton(
        icon: Icon(
          Icons.expand_less,
          // Icons.add,
          color: ColorConsts.DarkTextPrimary,
          // color: Colors.red,
        ),
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('棋谱', style: TextStyle(color: ColorConsts.Primary)),
              content:
                  SingleChildScrollView(child: Text(text, style: manualStyle)),
              actions: <Widget>[
                FlatButton(
                  child: Text('好的'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  engineToGo() async {
    changeStatus('对方思考中.....');

    final response = await CloudEngine().search(Battle.shared.phase);

    // 引擎返回'move'表示有最佳着法可用
    if (response.type == 'move') {
      final step = response.value;
      Battle.shared.move(step.from, step.to); //更新移动棋子

      final result = Battle.shared.scanBattleResult(); //对战结果
      switch (result) {
        case BattleResult.Pending:
          changeStatus('请走棋...');
          break;
        case BattleResult.Win:
          changeStatus('你羸了');
          break;
        case BattleResult.Lose:
          // todo:
          break;
        case BattleResult.Draw:
          // todo:
          break;
      }
    } else {
      print('没有取得下法,云主机计算出错?');
      changeStatus('出错:${response.type}');
    }
  }

  @override
  Widget build(BuildContext context) {
    calcScreenPaddingH(); //计算应用多少的宽度

    final header = createPageHeader();
    final board = createBoard();
    final operatorBar = createOperatorBar();
    final footer = buildFooter();

    // 在原有从上到下布局中，添加底部着法列表
    return Scaffold(
      backgroundColor: ColorConsts.DarkBackground,
      body: Column(
        children: <Widget>[
          header,
          board,
          operatorBar,
          footer,
        ],
      ),
    );
  }
}
