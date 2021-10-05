import 'dart:async';
import 'dart:io';

import 'package:admin_eshop/constants/ApiPaths.dart';
import 'package:admin_eshop/constants/AppConstants.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class RestApiService {
  /// Fires a Get request to an endpoint('path')
  /// Note that query params MUST BE STRINGS or lists of strings.
  static Future<http.Response> get(String path,
      [Map<String, dynamic> queryParams = const {}]) async {
    final url = Uri.https(ApiPaths.base, path, queryParams);
    print('url is $url');
    return retry(
        () => http
            .get(url, headers: AppConstants.apiHeaders)
            .timeout(Duration(seconds: 4)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 4);
  }

  static Future<http.Response> post(String path,
      [Object? requestBody,
      Map<String, dynamic> queryParams = const {}]) async {
    final url = Uri.https(ApiPaths.base, path, queryParams);
    print('post url is $url');
    print('post url payload is $requestBody');
    return retry(
        () => http
            .post(url, headers: AppConstants.apiHeaders, body: requestBody)
            .timeout(Duration(seconds: 4)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 4);
  }

  static Future<http.Response> put(String path,
      [Object? requestBody,
      Map<String, dynamic> queryParams = const {}]) async {
    final url = Uri.https(ApiPaths.base, path, queryParams);
    print(url);
    print(requestBody);
    return retry(
        () => http
            .put(url, headers: AppConstants.apiHeaders, body: requestBody)
            .timeout(Duration(seconds: 4)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 4);
  }
}
