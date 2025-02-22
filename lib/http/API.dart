import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/subject_entity.dart';
import 'package:flutter_douban/http/http_request.dart';
import 'package:flutter_douban/http/mock_request.dart';
import 'dart:math' as math;

import 'package:palette_generator/palette_generator.dart';

typedef RequestCallBack<T> = void Function(T value);


class API {
  static const BASE_URL = 'https://api.douban.com';

  ///TOP250
  static const String TOP_250 = '/v2/movie/top250';

  ///TOP250
  static const String DOUBAN_TOP_250 = '/v2/movie/doubanTop250';

  ///正在热映
  static const String IN_THEATERS = '/v2/movie/in_theaters?apikey=0b2bdeda43b5688921839c8ecb20399b';

  ///即将上映
  static const String COMING_SOON = '/v2/movie/coming_soon?apikey=0b2bdeda43b5688921839c8ecb20399b';

  ///一周口碑榜
  static const String WEEKLY = '/v2/movie/weekly?apikey=0b2bdeda43b5688921839c8ecb20399b';

  ///影人条目信息
  static const String CELEBRITY = '/v2/movie/celebrity/';

  static const String REIVIEWS = '/v2/movie/subject/26266893/reviews';

  bool useNetData = false;

  final _request = HttpRequest(API.BASE_URL);

  final _mockRequest = MockRequest();

  Future<dynamic> _query(String uri, String value) async {
    final result = await _request
        .get('$uri$value?apikey=0b2bdeda43b5688921839c8ecb20399b');
    return result;
  }

  ///当日可播放电影已经更新
  void getTodayPlay(RequestCallBack requestCallBack) async{
    int start = math.Random().nextInt(220);
    final Map result = await _request.get('$TOP_250?start=$start&count=4');
    var resultList = result['subjects'];
    List<Subject> list =
    resultList.map<Subject>((item) => Subject.fromMap(item)).toList();
    List<String> todayUrls = [];
    todayUrls.add(list[0].images?.medium);
    todayUrls.add(list[1].images?.medium);
    todayUrls.add(list[2].images?.medium);

    var paletteGenerator =
    await PaletteGenerator.fromImageProvider(NetworkImage(list[0].images?.small));
    var todayPlayBg = const Color(0x44000000);
    if (paletteGenerator != null && paletteGenerator.colors.isNotEmpty) {
      todayPlayBg = (paletteGenerator.colors.toList()[0]);
    }
    requestCallBack({'list':todayUrls, 'todayPlayBg':todayPlayBg});
  }

  void top250(RequestCallBack requestCallBack, {count = 250}) async {
    final Map result;
    if (useNetData) {
      result = await await _request.get('$TOP_250?start=0&count=$count&apikey=0b2bdeda43b5688921839c8ecb20399b');
    } else {
      result = await _mockRequest.get(API.TOP_250);
    }
    print(result);
    // final Map result = await _request.get('$TOP_250?start=0&count=$count&apikey=0b2bdeda43b5688921839c8ecb20399b');
    var resultList = result['subjects'];
    List<Subject> list =
        resultList.map<Subject>((item) => Subject.fromMap(item)).toList();
    requestCallBack(list);
  }
}