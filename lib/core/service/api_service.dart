import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/core/config/config.dart';
import 'package:restaurant_app/core/config/route_endpoint.dart';
import 'package:restaurant_app/core/response/add_review_response.dart';
import 'package:restaurant_app/core/response/detail_restaurant_response.dart';
import 'package:restaurant_app/core/response/list_restaurants_response.dart';
import 'package:restaurant_app/core/response/search_restaurant_response.dart';

class ApiService {
  Future<dynamic> _requestGet(String endpoint, String message) async {
    try {
      Uri uri = Uri(scheme: scheme, host: host, path: endpoint);
      final Map<String, String> headers = {'Accept': 'application/json'};

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
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
      Uri uri = Uri(scheme: scheme, host: host, path: endpoint);
      final Map<String, String> headers = {'Content-Type': 'application/json'};

      final response = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
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

  Future<SearchRestaurantResponse> searchRestaurant(String query) async {
    final response = await _requestGet(
      '$searchRestaurant?q=$query',
      'Tidak Ada restaurant yang ditemukan',
    );
    return SearchRestaurantResponse.fromJson(response);
  }

  Future<AddReviewResponse> addReview(List<Map<String, dynamic>> body) async {
    final response = await _requestPost(
      reviewRestaurant,
      'Gagal menambahkan review',
      {'customerReviews': body},
    );
    return AddReviewResponse.fromJson(response);
  }
}
