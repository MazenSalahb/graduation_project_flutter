import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/services/apis/baseurl.dart';

class BooksServiceApi {
  final dio = Dio();

  Future<List<BookModel>> getBooks() async {
    try {
      final response = await dio.get('$baseUrl/books',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
          }));
      if (response.statusCode == 200) {
        final List<BookModel> books = [];
        for (var item in response.data) {
          books.add(BookModel.fromJson(item));
        }
        return books;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<BookModel>> getBooksForSwap() async {
    try {
      final response = await dio.get('$baseUrl/books/swap',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
          }));
      if (response.statusCode == 200) {
        final List<BookModel> books = [];
        for (var item in response.data) {
          books.add(BookModel.fromJson(item));
        }
        return books;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<BookModel>> getUserBooks({required int userId}) async {
    try {
      final response = await dio.get('$baseUrl/books/user/$userId',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
          }));
      if (response.statusCode == 200) {
        final List<BookModel> books = [];
        for (var item in response.data) {
          books.add(BookModel.fromJson(item));
        }
        return books;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> addBook({
    required String title,
    required String author,
    required String description,
    required String category,
    required String status,
    required String availability,
    required String coverImage,
    required String token,
    String? price,
  }) async {
    log('coverImage: $coverImage');
    try {
      final response = await dio.post('$baseUrl/books',
          data: {
            'title': title,
            'author': author,
            'description': description,
            'category_id': category,
            'image': coverImage,
            'status': status,
            'availability': availability,
            'price': price,
          },
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }

  Future<bool> deleteBook({required num bookId, required String token}) async {
    try {
      final response = await dio.delete('$baseUrl/books/$bookId',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }
}
