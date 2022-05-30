import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlacesInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token': dotenv.env['MAPBOX_ACCESS_TOKEN'],
      'language': 'es',
      'limit': 7,
    });

    super.onRequest(options, handler);
  }
}
