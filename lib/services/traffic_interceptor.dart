import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline',
      'language': 'es',
      'overview': 'simplified',
      'steps': true,
      'access_token': dotenv.env['MAPBOX_ACCESS_TOKEN'],
    });
    super.onRequest(options, handler);
  }
}
