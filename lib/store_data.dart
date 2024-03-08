
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'background_service.dart';

class StoreDataLocally{
  static  late SharedPreferences _instance;
  static Future<SharedPreferences> init() async => _instance = await SharedPreferences.getInstance();

  static Future<bool> setString(String key, String? value) async {
    return await _instance.setString(key, value ?? "");
  }

  static Future<void> deleteData() async {
    _instance = await SharedPreferences.getInstance();
    await _instance.remove("trackData");
  }

  static Future<void> saveDataList(List<UserInfo> dataList) async {
    _instance = await SharedPreferences.getInstance();
    List<UserInfo> dd = await StoreDataLocally.loadDataList();
    dataList.addAll(dd);
    final jsonList = dataList.map((data) => data.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _instance.setString("trackData", jsonString);
  }

  static Future<List<UserInfo>> loadDataList() async {
    final jsonString = _instance.getString("trackData");
    if (jsonString != null) {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList.map((json) => UserInfo.fromJson(json)).toList();
    } else {
      return []; // Return empty list if no data found
    }
  }
}