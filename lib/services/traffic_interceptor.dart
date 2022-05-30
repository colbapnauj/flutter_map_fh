import 'package:dio/dio.dart';

const accessToken =
    'pk.eyJ1IjoiY29sYmFwbmF1aiIsImEiOiJja3YxMXQyMXQwZ3UyMzJtczk0aGExemc2In0.eh5uL3I2VGXsy1SH87NOIQ';

class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline',
      'language': 'es',
      'overview': 'simplified',
      'steps': true,
      'access_token': accessToken
    });
    super.onRequest(options, handler);
  }
}
