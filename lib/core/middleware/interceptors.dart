import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:processo_seletivo_onfly/core/provider/databases/local_storage.dart';
import 'package:processo_seletivo_onfly/shared/static/variables_static.dart';

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final path = options.path.replaceAll('[LOGIN_FORNECIDO]', dotenv.get('LOGIN'));
    options.path = path;
    options.headers = {
      'Authorization': await LocalStorage.instance.onGet(VariablesStatic.TOKEN)
    };
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}