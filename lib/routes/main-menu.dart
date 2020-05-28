import 'package:flutter/material.dart';
import '../common/color-consts.dart';
import '../main.dart';
import 'battle-page.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameStyle = TextStyle(
      fontSize: 64,
      color: Colors.black,
    );

    final menuItemStyle = TextStyle(
      fontSize: 28,
      color: ColorConsts.Primary,
    );

    // 标题及菜单项的布局
    final menuItems = Center(
      child: Column(
        children: <Widget>[
          Expanded(child: SizedBox(), flex: 4),
          Text('中国象棋', style: nameStyle, textAlign: TextAlign.center),
          Expanded(child: SizedBox()),
          FlatButton(
            child: Text('单机对战', style: menuItemStyle),
            onPressed: () {},
          ),
          Expanded(child: SizedBox()),
          FlatButton(
            child: Text('挑战云主机', style: menuItemStyle),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BattlePage()),
              );
            },
          ),
          Expanded(child: SizedBox()),
          FlatButton(
            child: Text('排行榜', style: menuItemStyle),
            onPressed: () {},
          ),
          Expanded(child: SizedBox(), flex: 3),
          Text(
            '用心娱乐，为爱传承',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );

    // 页面整体
    return Scaffold(
      backgroundColor: ColorConsts.LightBackground,
      body: Stack(
        children: <Widget>[
          menuItems,
          // 为了在页面左上角显示设置按钮，我们使用了基于绝对位置的 Stack 布局
          Positioned(
            top: ChessRoadApp.StatusBarHeight,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.settings, color: ColorConsts.Primary),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
