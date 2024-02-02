import 'dart:io';
import 'dart:async';

import 'package:book_sharing_app/constants/env.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:book_sharing_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Book {
  String id;
  String name;
  String description;
  String review;
  String status;
  Photo photo;
  BookFile book;
  User user;
  int reactions;

  Book({
    required this.id,
    required this.name,
    required this.description,
    required this.review,
    required this.status,
    required this.photo,
    required this.book,
    required this.user,
    required this.reactions,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      review: json['review'],
      status: json['status'],
      photo: Photo.fromJson(json['photo']),
      book: BookFile.fromJson(json['book']),
      user: User.fromJson(json['user']),
      reactions: json['reactions'],
    );
  }

  //Get all books
  static Future<List<Book>> getAllBooks() async {
    await EasyLoading.show();
    final response = await http.get(Uri.parse('$baseUrl/books'),
        headers: {'Accept': 'application/json'});
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Book> books = [];
      for (var bookData in data['data']) {
        Book book = Book.fromJson(bookData);
        books.add(book);
      }
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  //Create Book
  static Future createBook(
      {required String userId,
      required String name,
      required String description,
      required String review,
      required File photo,
      required File book,
      required String status}) async {
    try {
      await EasyLoading.show();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/add-book'));
      var stream = http.ByteStream(Stream.castFrom(photo.openRead()));
      var length = await photo.length();
      var multipartFile = http.MultipartFile('photo', stream, length,
          filename: basename(photo.path));
      var stream2 = http.ByteStream(Stream.castFrom(book.openRead()));
      var length2 = await book.length();
      var multipartFile2 = http.MultipartFile('book', stream2, length2,
          filename: basename(book.path));
      request.headers['Authorization'] = 'Bearer $token';

      request.fields.addAll({
        'user': userId,
        'name': name,
        'description': description,
        'review': review,
        'status': status
      });
      request.files.add(multipartFile);
      request.files.add(multipartFile2);
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      EasyLoading.dismiss();
      if (response.statusCode == 201) {
        var data = json.decode(responseData.body);
        Book book = Book.fromJson(data['data']);
        print(book.name);
        return book;
      } else {
        throw Exception('Failed to create book');
      }
      print("hel ${response.statusCode}");
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      return 500;
    }
  }

  //Update Book
  static Future<Book> updateBook(
      {required String id,
      required String name,
      required String description,
      required String review,
      required String photo,
      required String book,
      required String status}) async {
    var data = {
      'name': name,
      'description': description,
      'review': review,
      'photo': photo,
      'book': book,
      'status': status
    };
    await EasyLoading.show();
    final response = await http.put(Uri.parse('$baseUrl/update-book/$id'),
        headers: {'Accept': 'application/json'}, body: json.encode(data));
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Book book = Book.fromJson(data['data']);
      return book;
    } else {
      throw Exception('Failed to update book');
    }
  }

  //Delete Book
  static Future<Book> deleteBook({required String id}) async {
    await EasyLoading.show();
    final response = await http.delete(Uri.parse('$baseUrl/delete-book/$id'),
        headers: {'Accept': 'application/json'});
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Book book = Book.fromJson(data['data']);
      return book;
    } else {
      throw Exception('Failed to delete book');
    }
  }
}

class Photo {
  String id;
  String publicPath;

  Photo({required this.id, required this.publicPath});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'].toString(),
      publicPath: json['public_path'],
    );
  }
}

// class User {
//   String id;
//   String name;
//   String email;
//   Profile profile;
//   String? description;
//   String createdAt;
//
//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.profile,
//     required this.description,
//     required this.createdAt,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'].toString(),
//       name: json['name'],
//       email: json['email'],
//       profile: Profile.fromJson(json['profile']),
//       description: json['description'],
//       createdAt: json['created_at'],
//     );
//   }
//   static Future<User> getUser({required dynamic token}) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/user'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//       User user = User.fromJson(data['data']);
//       return user;
//     } else {
//       throw Exception('Failed to load user');
//     }
//   }
// }

class Profile {
  String id;
  String publicPath;

  Profile({
    required this.id,
    required this.publicPath,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'].toString(),
      publicPath: json['public_path'],
    );
  }
}

class BookFile {
  String id;
  String publicPath;

  BookFile({
    required this.id,
    required this.publicPath,
  });

  factory BookFile.fromJson(Map<String, dynamic> json) {
    return BookFile(
      id: json['id'].toString(),
      publicPath: json['public_path'],
    );
  }
}
