import 'dart:convert';

import 'package:book_sharing_app/constants/env.dart';
import 'package:book_sharing_app/model/book.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookController extends GetxController {
  final isInProcess = false.obs;

  Future saveBook({required String userId, required String bookId}) async {
    if (isInProcess.value) return;
    isInProcess.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      print(token);

      final data = {'user_id': userId, 'book_id': bookId};

      final response = await http.post(Uri.parse("$baseUrl/add-to-cart"),
          headers: {
            'Accept': 'application/json',
            'Authorization': "Bearer $token",
          },
          body: data);

      isInProcess.value = false;
      return response.statusCode;
    } catch (e) {
      print(e);
      isInProcess.value = false;
      return 500;
    }
  }

  Future getBookInfo({required String bookId, required String userId}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      print(token);

      final data = {'user_id': userId, 'book_id': bookId};

      final response = await http.post(Uri.parse("$baseUrl/book-info"),
          headers: {
            'Accept': 'application/json',
            'Authorization': "Bearer $token",
          },
          body: data);

      final responseBody = response.body;
      final decodedData = json.decode(responseBody);
      print(decodedData['data']);
      return decodedData['data'];
    } catch (e) {
      print(e);
      return 500;
    }
  }

  Future getCarts({required String userId}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      print(token);

      final data = {'user_id': userId};

      final response = await http.post(Uri.parse("$baseUrl/cart"),
          headers: {
            'Accept': 'application/json',
            'Authorization': "Bearer $token",
          },
          body: data
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<Book> books = [];
        for (var bookData in data['data']) {
          print('heler book ddata');
          print(bookData);
          print('heler book ddata');

          Book book = Book.fromJson(bookData['book']);
          books.add(book);
        }
        return books;
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print(e);
      return 500;
    }
  }
}
