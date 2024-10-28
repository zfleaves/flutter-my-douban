import 'package:shared_preferences/shared_preferences.dart';

class CustomStorage {
  // 设置
  static Future<void> setString(key, value) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString(key, value);
    } catch (e) {
       print("【存储出错】${e.toString()}");
    }
  }

  // 获取
  static Future<String?> getString(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  // 删除
  static Future<void> remove(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(key);
  }

  // 清空
  static Future<void> clear() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}