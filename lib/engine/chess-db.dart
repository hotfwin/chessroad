import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class ChessDB {
  static const Host = 'www.chessdb.cn'; // 云库服务器
  static const Path = '/chessdb.php'; // API 路径

  //向云库查询最佳着法
  static Future<String> query(String board) async {
    Uri url = Uri(
      scheme: 'http',
      host: Host,
      path: Path,
      queryParameters: {
        'action':
            'queryall', //查询所有着法信息 (queryall)、自动出步 (query / querybest)、提交后台计算 (queue) 等
        'learn': '1',
        'showall': '1',
        'board': board,
      },
    );

    final httpClient = HttpClient();

    try {
      final request = await httpClient.getUrl(url);
      final response = await request.close();
      return await response.transform(utf8.decoder).join();
    } catch (e) {
      print('从中国象棋云库中取"着法"出错Error:$e');
    } finally {
      httpClient.close();
    }

    return null;
  }

  //请求云库在后台计算指定局面的最佳"着法"
  static Future<String> requestComputeBackground(String board) async {
    Uri url = Uri(
      scheme: 'http',
      host: Host,
      path: Path,
      queryParameters: {
        'action': 'queue', //提交后台计算 (queue)
        'board': board,
      },
    );

    final httpClient = HttpClient();

    try {
      final request = await httpClient.getUrl(url);
      final response = await request.close();
      return await response.transform(utf8.decoder).join();
    } catch (e) {
      print('从中国象棋云库中"提交后台计算"出错Error:$e');
    }finally{
      httpClient.close();
    }

    return null;
  }
}
