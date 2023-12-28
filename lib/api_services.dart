import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/controller/home_controller.dart';
import 'package:weather_app/secrets.dart';

class ApiServices {
  ApiServices._();
  static final ApiServices _instance = ApiServices._();

  factory ApiServices() => _instance;
  String apiUrlCurrent =
      'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}';
  String apiKey = Secrets.apiKey;

  final HomeController homeController = Get.put(HomeController());

  Future<dynamic> fetchData(double lat, double lon) async {
    final url = apiUrlCurrent
        .replaceFirst('{lat}', lat.toString())
        .replaceFirst('{lon}', lon.toString())
        .replaceFirst('{api_key}', apiKey);

    try {
      // var res = await http.get(Uri.parse(url));
      final response = await http.get(Uri.parse(url));
      return handleResponse(response);
    } catch (e) {
      debugPrint(e.toString());
      return {'statusCode': 500, 'message': 'Server not available', 'body': {}};
    }
  }

  dynamic handleResponse(dynamic res) {
    try {
      if (res.statusCode != 500) {
        var jsonResponse = jsonDecode(res.body);
        debugPrint(jsonResponse.toString());
        jsonResponse['statusCode'] = res.statusCode;
        return jsonResponse;
      } else {
        return {
          'statusCode': 500,
          'message': 'Internal Server Error',
          'body': {}
        };
      }
    } catch (e) {
      debugPrint(e.toString());
      return {'statusCode': 500, 'message': 'Server not available', 'body': {}};
    }
  }
}
