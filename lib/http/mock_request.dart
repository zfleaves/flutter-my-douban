import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:flutter_douban/http/API.dart';

///模拟数据
class MockRequest {
  Future<dynamic> get(String action, {Map? params}) async {
    return mock(action: getJsonName(action), params: params);
  }

  Future<dynamic> post({String? action, Map? params}) async {
    return mock(action: action, params: params);
  }

  Future<dynamic> mock({String? action, Map? params}) async {
    var responseStr = await rootBundle.loadString('mock/$action.json');
    var responseJson = json.decode(responseStr);
    return responseJson;
  }

  Future<dynamic> mock2(String action) async {
    var responseStr = await rootBundle.loadString('mock/$action.json');
    var responseJson = json.decode(responseStr);
    return responseJson;
  }

  Map<String, String> map = {
    API.IN_THEATERS: 'in_theaters',
    API.COMING_SOON: 'coming_soon',
    API.TOP_250: 'top250',
    API.DOUBAN_TOP_250: 'doubanTop250',
    API.WEEKLY: 'weekly',
    API.REIVIEWS: 'reviews',
  };

  getJsonName(String action) {
    return map[action];
  }
}
