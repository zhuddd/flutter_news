import 'http_service.dart';

class ApiService {
  // 用户注册
  static Future<dynamic> register(
      String username, String email, String password) async {
    final response = await HttpService().post('/auth/local/register', data: {
      'username': username,
      'email': email,
      'password': password,
    });
    return response;
  }

  // 用户登录
  static Future<dynamic> login(String identifier, String password) async {
    final response = await HttpService().post('/auth/local', data: {
      'identifier': identifier, // 可以是 username 或 email
      'password': password,
    });
    return response;
  }

  static Future<dynamic> getMe(String token) async {
    final response = await HttpService().get('/profile', headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });
    return response;
  }

  static Future<dynamic> getOne(String token, String documentId) async {
    final response = await HttpService().get('/profile/$documentId}', headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });
    return response;
  }

  // 更新用户信息（示例）
  static Future<dynamic> updateUserInfo(
      String token, Map<String, dynamic> data) async {
    final response = await HttpService().put('/users/me', data: data, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });
    return response;
  }

  // 获取文章列表
  static Future<dynamic> getArticles({num page = 1, num pageSize = 10}) async {
    final response = await HttpService().get(
        '/informations?pagination[page]=$page&pagination[pageSize]=$pageSize');
    return response;
  }
  // 获取文章列表
  static Future<dynamic> getOneArticle({required String documentId}) async {
    final response = await HttpService().get(
        '/informations/$documentId');
    return response;
  }
}
