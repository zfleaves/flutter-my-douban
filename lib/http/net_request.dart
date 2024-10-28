import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_douban/bean/i_movie_detail_entity.dart';
import 'package:flutter_douban/bean/i_share_image_entity.dart';
import 'package:flutter_douban/bean/i_top_entity.dart';
import 'package:flutter_douban/constant/cache_key.dart';
import 'package:flutter_douban/constant/constant.dart';
import 'package:flutter_douban/constant/net_path.dart';
import 'package:flutter_douban/http/API.dart';
import 'package:flutter_douban/http/http_util.dart';
import 'package:flutter_douban/http/mock_request.dart';
import 'package:flutter_douban/services/Storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetRequest {
  // <List<ITopEntity>>
  static Future<List<ITopEntity>> getTopList(int skip,int limit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool useSourceData = prefs.getBool(CacheKey.USE_SOURCE_DATA) ?? false;
    // String type = useSourceData ? 'Douban' : 'Imdb';
    String type = 'Douban';
    String key = 'topList-$skip-$limit-$type';
    try {
      final topList = json.decode(await CustomStorage.getString(key) as String);
      List<ITopEntity> list = topList.map<ITopEntity>((item) => ITopEntity.fromMap(item)).toList();
      return list;
    } catch (e) {
      String url = NetPath.getTop250(skip, limit, type);
      print(url);
      final result = await HttpUtil.getInstance().get(url, null);
      List<ITopEntity> list = result.map<ITopEntity>((item) => ITopEntity.fromMap(item)).toList();
      CustomStorage.setString(key, json.encode(result));
      return list;
    }
  }

  ///电影详情数据解析
  static Future<IMovieDetailEntity> getMovieDetail(String doubanid) async{
    String key = 'movieDetail-$doubanid';
    try {
      final movieDetail =  json.decode(await CustomStorage.getString(key) as String);
      return IMovieDetailEntity.fromMap(movieDetail);
    } catch (e) {
      print(333333333333);
      String url = NetPath.getMovieDetail(doubanid);
      final result = await HttpUtil.getInstance().get(url, null);
      CustomStorage.setString(key, json.encode(result));
      return IMovieDetailEntity.fromMap(result);
    }
  }


  ///电影搜索列表解析
  static Future<List<ITopEntity>?> getSearchList(String key) async {
    try {
      final List<ITopEntity> list = await getAllTopList(0, 250);
      var resultList = list.where((ITopEntity entity) {
        String name = entity.data[0].name;
        String originalName = entity.originalName;
        return name.toLowerCase().contains(key.toLowerCase()) || originalName.toLowerCase().contains(key.toLowerCase());  
      }).toList();
      print('getSearchList-$resultList');
      return resultList;
    } catch (e) {
      print("【电影搜索列表解析出错】${e.toString()}");
      return [];
    }
  }

  static Future<List<ITopEntity>> getAllTopList(int skip,int limit) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool useSourceData = prefs.getBool(CacheKey.USE_SOURCE_DATA) ?? false;
    // String type = useSourceData ? 'Douban' : 'Imdb';
    // String key = 'topList-$skip-$limit-$type';
    // try {
    //   final topList = json.decode(await CustomStorage.getString(key) as String);
    //   List<ITopEntity> list = topList.map<ITopEntity>((item) => ITopEntity.fromMap(item)).toList();
    //   return list;
    // } catch (e) {
    //   String url = NetPath.getTop250(skip, limit, type);
    //   final result = await HttpUtil.getInstance().get(url, null);
    //   List<ITopEntity> list = result.map<ITopEntity>((item) => ITopEntity.fromMap(item)).toList();
    //   CustomStorage.setString(key, json.encode(result));
    //   return list;
    // }
    final _mockRequest = MockRequest();
    List result = await _mockRequest.get(API.DOUBAN_TOP_250);
    // print(result);
    // result = result.sublist(0, 2);
    List<ITopEntity> list = result.map<ITopEntity>((item) => ITopEntity.fromMap(item)).toList();
    // print(list);
    return list;
    // return [];
  }


  ///分享图片解析
  static Future<IShareImageEntity> getShareImage(String doubanId) async {
    String key = 'shareImage-$doubanId';
    try {
      final shareDetail =  json.decode(await CustomStorage.getString(key) as String);
      return IShareImageEntity.fromMap(shareDetail);
    } catch (e) {
      String url = NetPath.getShareImage(doubanId);
      final result = await HttpUtil.getInstance().get(url, null);
      CustomStorage.setString(key, json.encode(result));
      return IShareImageEntity.fromMap(result);
    }
  }

  static Future getCartList() async {
    var url = '${Constant.domain}api/pcate?pid=59f1e1ada1da8b15d42234e9';
    final result = await HttpUtil.getInstance().get(url, null);
    print(result);
    return result;
  }
}
