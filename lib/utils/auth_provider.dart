import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'api_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _userInfo;
  bool _isLoggedIn=false;

  String? get token => _token;

  Map<String, dynamic>? get userInfo => _userInfo;

  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    loadFromStorage().then((_) {
      checkLoginStatus();
    });
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/auth_data.json');
  }

  Future<void> _saveToFile() async {
    final file = await _getLocalFile();
    final data = {
      'token': _token,
    };
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> loadFromStorage() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content) as Map<String, dynamic>;
        _token = data['token'];
        notifyListeners();
      }
    } catch (e) {
      print("Error loading auth data: $e");
    }
  }

  Future<void> setToken(String token) async {
    _token = token;
    await _saveToFile();
    notifyListeners();
  }

  Future<void> setUserInfo(Map<String, dynamic> userInfo) async {
    _userInfo = userInfo;
    await _saveToFile();
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _userInfo = null;
    _isLoggedIn = false;
    final file = await _getLocalFile();
    if (await file.exists()) {
      await file.delete();
    }
    notifyListeners();
  }

  // 只在第一次加载时调用 API 来验证 token 是否有效
  Future<bool> checkLoginStatus() async {
    try {
      // 尝试获取用户信息，验证 token 是否有效
      final userInfo = await ApiService.getMe(_token!);
      if (userInfo != null && userInfo.isNotEmpty) {
        _userInfo = userInfo['data'];
        _isLoggedIn = true;
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      _isLoggedIn = false;
    }
    return _isLoggedIn ?? false;
  }
}
