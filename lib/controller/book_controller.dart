import 'dart:convert';

import 'package:book_sharing_app/constants/env.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/book.dart';

class BookController extends GetxController {
  final isInProcess = false.obs;
  RxList<Book> books = <Book>[].obs;
  Future<void> loadBooks() async {
    List<Book> fetchedBooks = await Book.getAllBooks();
    books.value = fetchedBooks;
  }

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
}
