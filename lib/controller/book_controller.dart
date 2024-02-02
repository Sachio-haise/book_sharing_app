import 'dart:convert';

import 'package:book_sharing_app/constants/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/book.dart';

class BookController extends GetxController {
  final isInProcess = false.obs;
  var message = "";
  RxList<Book> books = <Book>[].obs;
  RxList<Book> carts = <Book>[].obs;
  RxList<Book> bookByAuthor = <Book>[].obs;

  Future<void> loadBooks(
  {
    required bool load
}
      ) async {
    List<Book> fetchedBooks = await Book.getAllBooks(load:load);
    books.value = fetchedBooks;
  }

  Future<void> loadCart({required String userId}) async {
    List<Book> fetchedCarts = await getCarts(userId: userId);
    carts.value = fetchedCarts;
  }

  void findBooksByAuthor(String author) {
    bookByAuthor.value = books
        .where((b) =>
            (b.user.name ?? '').toLowerCase() == author.toLowerCase() &&
            author.isNotEmpty)
        .toList();
  }

  Future saveBook( String userId, String bookId, BuildContext context) async {
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
          body: data
      );
      final responseBody = response.body;
      final decodedResponse = json.decode(responseBody);

      message = decodedResponse['message'];
      _showSuccessSnackBar(context);
      isInProcess.value = false;
      return response.statusCode;
    } catch (e) {
      print(e);
      isInProcess.value = false;
      return 500;
    }
  }

  Future reactBook({required String userId, required String bookId}) async {
    if (isInProcess.value) return;
    isInProcess.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      print(token);

      final data = {'user_id': userId, 'book_id': bookId};

      final response = await http.post(Uri.parse("$baseUrl/react-book"),
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

  _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.green.shade100,
      ),
    );
  }

  _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Error occurred!',
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.red.shade100,
      ),
    );
  }

  Future removeFromCart(String id, String author, BuildContext context) async{
    await EasyLoading.show();
    try{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final data = {
        "user_id": author,
        "book_id":id
      };
      final response = await http.post(
        Uri.parse("$baseUrl/add-to-cart"),
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
        body:data
      );
      EasyLoading.dismiss();
      final responseBody = response.body;
      if (responseBody.isNotEmpty) {
        await loadCart(userId: author);
        findBooksByAuthor(author);
        message = "Book Unsaved successfully!";
        _showSuccessSnackBar(context);
      }
      final decodedData = json.decode(responseBody);
      print(decodedData['data']);
    }catch (e) {
      _showErrorSnackBar(context);
      EasyLoading.dismiss();
      print(e);
      return 500;
    }
  }

  Future deleteBook(String id, String author, BuildContext context) async {
    await EasyLoading.show();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse("$baseUrl/delete-book/$id"),
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      EasyLoading.dismiss();
      final responseBody = response.body;
      if (responseBody.isNotEmpty) {
        await loadBooks(load: true);
        findBooksByAuthor(author);
        message = "Book deleted successfully!";
        _showSuccessSnackBar(context);
      }
      final decodedData = json.decode(responseBody);

      print(decodedData['data']);
      return decodedData['data'];
    } catch (e) {
      _showErrorSnackBar(context);
      EasyLoading.dismiss();
      print(e);
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
          body: data);
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
