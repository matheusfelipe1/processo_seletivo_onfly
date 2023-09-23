import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'interceptors.dart';

class CustomHttp {
  final client = Dio()
    ..options.baseUrl = dotenv.get('BASE_URL')
    ..interceptors.add(CustomInterceptors())
    ..options.connectTimeout = const Duration(seconds: 8);
  
}