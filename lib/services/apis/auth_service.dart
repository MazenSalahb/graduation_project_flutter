import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/services/apis/baseurl.dart';

class AuthService {
  final dio = Dio();

  Future<Map<String, dynamic>?>? login(String email, String password) async {
    try {
      final res = await dio.post(
        '$baseUrl/signin',
        data: {
          'email': email,
          'password': password,
        },
      );
      if (res.statusCode == 200) {
        return res.data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return null;
    }
  }

  Future<bool> register(
      {required String name,
      required String email,
      required String location,
      required String password}) async {
    try {
      final res = await dio.post(
        '$baseUrl/signup',
        data: {
          'name': name,
          'email': email,
          'location': location,
          'password': password,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
          },
        ),
      );
      if (res.statusCode == 201) {
        if (res.data['status'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }
}
