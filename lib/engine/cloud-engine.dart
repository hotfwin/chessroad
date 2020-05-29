import 'package:flutter/material.dart';

import '../cchess/cc-base.dart';
import '../cchess/phase.dart';
import 'chess-db.dart';

/// 引擎查询结果包裹
/// type 为 move 时表示正常结果反馈，value 用于携带结果值
/// type 其它可能值至少包含：timeout / nobestmove / network-error / data-error
class EngineResponse {
  final String type;
  final dynamic value;
  EngineResponse(this.type, {this.value});
}

class CloudEngine {
  /// 向云库查询某一个局面的最佳"着法"
  /// 如果一个局面云库没有遇到过，则请求云库后台计算，并等待云库的计算结果
  Future<EngineResponse> search(Phase phase, {bool byUser = true}) async {
    final fen = phase.toFen();
    var response = await ChessDB.query(fen); //查询最佳"着法"

    //发生网络错误,直接返回
    if (response == null) {
      print('网络错误');
      return EngineResponse('network-error');
    }

    if (!response.startsWith('move:')) {
      print('没有查到最佳"着法"');
      print('ChessDB.query: $response\n');
    } else {
      print('有着法列表返回');
      //move:h7g7,score:-3,rank:2,note:! (45-13),winrate:49.77|move:c6c5,score:-27,rank:0,note:? (44-02),winrate:47.96|move:g9e7,score:-43,rank:0,note:? (44-02),winrate:46.75|move:c9e7,score:-45,rank:0,note:? (44-08),winrate:46.60|move:b9c7,score:-63,rank:0,note:? (43-01),winrate:45.24|move:h9i7,score:-68,rank:0,note:? (43-01),winrate:44.87|move:b7d7,score:-68,rank:0,note:? (45-03),winrate:44.87|move:b7e7,score:-69,rank:0,note:? (45-02),winrate:44.79|move:b7f7,score:-71,rank:0,note:? (45-02),winrate:44.64|move:h9g7,score:-72,rank:0,note:? (43-01),winrate:44.57|move:h7d7,score:-79,rank:0,note:? (45-01),winrate:44.04|move:h7e7,score:-79,rank:0,note:? (45-01),winrate:44.04|move:b9a7,score:-84,rank:0,note:? (43-02),winrate:43.67|move:b7g7,score:-88,rank:0,note:? (45-01),winrate:43.37|move:h7f7,score:-108,rank:0,note:? (45-01),winrate:41.89|move:b7a7,score:-109,rank:0,note:? (45-01),winrate:41.82|move:i6i5,score:-129,rank:0,note:? (44-01),winrate:40.35|move:a6a5,score:-130,rank:0,note:? (44-01),winrate:40.28|move:d9e8,score:-131,rank:0,note:? (44-01),winrate:40.20|move:f9e8,score:-131,rank:0,note:? (44-01),winrate:40.20|move:g6g5,score:-141,rank:0,note:? (44-01),winrate:39.48|move:b7c7,score:-142,rank:0,note:? (45-01),winrate:39.41|move:h7i7,score:-142,rank:0,note:? (45-01),winrate:39.41|move:b7b5,score:-155,rank:0,note:? (42-01),winrate:38.47|move:b7b8,score:-156,rank:0,note:? (45-01),winrate:38.40|move:h7c7,score:-156,rank:0,note:? (45-01),winrate:38.40|move:h7h8,score:-156,rank:0,note:? (45-01),winrate:38.40|move:g9i7,score:-159,rank:0,note:? (44-01),winrate:38.18|move:h7h5,score:-163,rank:0,note:? (42-01),winrate:37.90|move:c9a7,score:-193,rank:0,note:? (44-02),winrate:35.78|move:h7h3,score:-195,rank:0,note:? (40-01),winrate:35.64|move:b7b3,score:-196,rank:0,note:? (40-01),winrate:35.57|move:e6e5,score:-202,rank:0,note:? (44-01),winrate:35.16|move:b7b4,score:-214,rank:0,note:? (41-01),winrate:34.33|move:h7h6,score:-222,rank:0,note:? (43-01),winrate:33.79|move:b7b6,score:-222,rank:0,note:? (43-01),winrate:33.79|move:h7h4,score:-252,rank:0,note:? (41-01),winrate:31.79|move:h7h0,score:-291,rank:0,note:? (41-01),winrate:29.28|move:e9e8,score:-294,rank:0,note:? (44-02),winrate:29.09|move:b7b0,score:-319,rank:0,note:? (41-01),winrate:27.55|move:a9a8,score:-325,rank:0,note:? (44-01),winrate:27.19|move:a9a7,score:-325,rank:0,note:? (44-01),winrate:27.19|move:i9i7,score:-347,rank:0,note:? (44-01),winrate:25.89|move:i9i8,score:-347,rank:0,note:? (44-01),winrate:25.89
      final firstStep = response.split('|')[0];
      print('最佳"着法"-ChessDB.query: $firstStep');

      final segments = firstStep.split(',');
      if (segments.length < 2) {
        print('云库返回着法数据和预算理不对');
        return EngineResponse('data-error');
      }

      final move = segments[0], score = segments[1];

      final scoreSegments = score.split(':');
      if (scoreSegments.length < 2) return EngineResponse('data-error');
      final moveWithScore = int.tryParse(scoreSegments[1]) != null; //转换为整型

      //存在有效"着法"
      if (moveWithScore) {
        final step = move.substring(5);

        if (Move.validateEngineStep(step)) {
          return EngineResponse(
            'move',
            value: Move.fromEngineStep(step),
          );
        }
      } else {
        //云库没有遇到过这个局面，请求它执行后台计算
        if (byUser) {
          response = await ChessDB.requestComputeBackground(fen);
          print('云库正在计算下法-ChessDB.requestComputeBackground: $response\n');
        }
        // 这里每过2秒就查看它的计算结果
        return Future<EngineResponse>.delayed(
          Duration(seconds: 2),
          () => search(phase, byUser: false),
        );
      }
    }
    print('没有"最佳着法",也没有计算到"下法"');
    return EngineResponse('unknown-error');

  }

  
}
