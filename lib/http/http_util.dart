import 'package:dio/dio.dart';
import 'package:flutter_douban/constant/net_path.dart';

class HttpUtil {
  // default options
  static const _connectTimeout = Duration(seconds: 30); //15s
  static const _receiveTimeout = Duration(seconds: 30);
  static const _sendTimeout = Duration(seconds: 30);
  // METHOD
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  static var _dio;
  static HttpUtil? _httpUtil;

  static HttpUtil getInstance() => _httpUtil ??= HttpUtil();

  // 创建 dio 实例对象
  Dio _createInstance() {
    if (_dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      var options = BaseOptions(
        // responseType: ResponseType.json,
        baseUrl: NetPath.BaseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
      );

      var interceptor = InterceptorsWrapper(
          // 请求数据拦截
          onRequest: (options, handler) {
        return handler.next(options);
      },
          // 响应数据拦截
          onResponse: (
        response,
        handler,
      ) {
        return handler.next(response);
      },
          // 错误响应数据拦截
          onError: (e, handler) {
        return handler.next(e);
      });

      _dio = Dio(options);
      _dio.interceptors.add(interceptor);
      print(_dio);
    }
    return _dio;
  }

  Future get<t>(String url, FormData? params) async {
    return _requestHttp(
      url,
      params: params,
      method: GET,
    );
  }

  Future<T> post<T>(String url, FormData params) async {
    return _requestHttp<T>(
      url,
      params: params,
      method: POST,
    );
  }

  _requestHttp<T>(String url, {params, method}) async {
    _dio = _createInstance();
    try {
      Response response;
      if (method == 'get') {
        response = await _dio.get(url);
      } else {
        response = await _dio.post(url, data: params);
      }
      print(response);
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      /// 打印请求失败相关信息
      print("【请求出错】${e.toString()}");
      rethrow;
    }
  }

  // 清空 dio 对象
  clear() {
    _dio = null;
  }
}
