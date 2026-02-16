import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/core/config/config.dart';
import 'package:restaurant_app/core/config/route_endpoint.dart';
import 'package:restaurant_app/core/response/add_review_response.dart';
import 'package:restaurant_app/core/response/detail_restaurant_response.dart';
import 'package:restaurant_app/core/response/list_restaurants_response.dart';
import 'package:restaurant_app/core/response/search_restaurant_response.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:restaurant_app/core/error/exceptions.dart';

class ApiService {
  Future<bool> _ensureInternetConnection() async {
    if (kIsWeb) {
      return true;
    }
    var connectivityResult = await (Connectivity().checkConnectivity());

    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      bool hasInternet = await InternetConnection().hasInternetAccess;
      if (!hasInternet) {
        throw NetworkException('Tidak ada WIFI atau internet yang tersambung');
      }
      return true;
    }
  }

  Future<dynamic> _requestGet(
    String endpoint,
    String message, {
    String? queryParameters,
  }) async {
    try {
      await _ensureInternetConnection();
      Uri uri = Uri(
        scheme: scheme,
        host: host,
        path: endpoint,
        queryParameters: {'q': queryParameters},
      );

      final Map<String, String> headers = {'Accept': 'application/json'};

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on NetworkException {
      rethrow;
    } on TimeoutException {
      throw Exception('Koneksi timeout, silakan coba lagi.');
    } catch (e) {
      throw Exception(message);
    }
  }

  Future<dynamic> _requestPost(
    String endpoint,
    String message,
    Map<String, dynamic> body,
  ) async {
    try {
      await _ensureInternetConnection();
      final fullUrl = '$scheme://$host$endpoint';
      final uri = Uri.parse(fullUrl);
      final Map<String, String> headers = {'Content-Type': 'application/json'};

      final response = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on NetworkException {
      rethrow;
    } on TimeoutException {
      throw Exception('Koneksi timeout, silakan coba lagi.');
    } catch (e) {
      throw Exception(message);
    }
  }

  Future<ListRestaurantsResponse> getListRestaurants() async {
    final response = await _requestGet(
      listRestaurant,
      'Tidak Ada restaurant yang ditemukan',
    );
    return ListRestaurantsResponse.fromJson(response);
  }

  Future<DetailRestaurantResponse> getDetailRestaurant(String id) async {
    final response = await _requestGet(
      '$detailRestaurant/$id',
      'informasi tentang restaurant ini tidak ditemukan',
    );
    return DetailRestaurantResponse.fromJson(response);
  }

  Future<SearchRestaurantResponse> getSearchRestaurant(String query) async {
    final response = await _requestGet(
      searchRestaurant,
      'Tidak Ada restaurant yang ditemukan',
      queryParameters: query,
    );
    return SearchRestaurantResponse.fromJson(response);
  }

  Future<AddReviewResponse> addReview(
    String id,
    String name,
    String review,
  ) async {
    final response = await _requestPost(
      reviewRestaurant,
      'Gagal menambahkan review',
      {'id': id, 'name': name, 'review': review},
    );
    return AddReviewResponse.fromJson(response);
  }
}
