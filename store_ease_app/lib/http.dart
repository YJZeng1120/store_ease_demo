import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'models/core/api_config.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 3), // response == null
    receiveTimeout: const Duration(seconds: 5),
  ),
);

// For error handle
final logger = Logger(
  printer: PrettyPrinter(
    printTime: true,
  ),
);
