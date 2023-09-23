import 'dart:convert';
import 'package:processo_seletivo_onfly/core/middleware/custom_http.dart';

class DataSource {
  final _http = CustomHttp();

  Future<dynamic> get(String path) async {
    final response = await _http.client.get(path);
    return response.data;
  }

  Future<dynamic> delete(String path) async {
    final response = await _http.client.delete(path);
    return response.data;
  }

  Future<dynamic> post(String path, Map body) async {
    final response = await _http.client.post(path, data: jsonEncode(body));
    return response.data;
  }

  Future<dynamic> patch(String path, Map body) async {
    final response = await _http.client.patch(path, data: jsonEncode(body));
    return response.data;
  }
}