import 'dart:io';

import 'package:book_sharing_app/constants/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// api data
//  "data": [
//         {
//             "id": 8,
//             "name": "Java",
//             "description": "This is Java Book Description",
//             "review": "This is Java Book One Review This is Book One Review This is Book One Review",
//             "status": "0",
//             "photo": {
//                 "id": 17,
//                 "public_path": "https://book-sharing-app-api.onrender.com/storage/media/book/book_java_281027/book-1706604704_609c593b.png"
//             },
//             "book": {
//                 "id": 18,
//                 "public_path": "https://book-sharing-app-api.onrender.com/storage/media/book/book_java_281027/book-1706604704_b7259bab.pdf"
//             },
//             "user": {
//                 "id": 5,
//                 "name": "Myo Min Ko",
//                 "email": "adminmk@gmail.com",
//                 "profile": {
//                     "id": 19,
//                     "public_path": "https://book-sharing-app-api.onrender.com/storage/media/user/tmpphpnpadno/user-1706605242_a91ba615.jpg"
//                 },
//                 "description": null,
//                 "created_at": "15 hours ago"
//             },
//             "reactions": 0
//         },
//         {
//             "id": 7,
//             "name": "Java",
//             "description": "This is Java Book Description",
//             "review": "This is Java Book One Review This is Book One Review This is Book One Review",
//             "status": "0",
//             "photo": {
//                 "id": 15,
//                 "public_path": "https://book-sharing-app-api.onrender.com/storage/media/book/book_java_447769/book-1706603887_eedac4c1.png"
//             },
//             "book": {
//                 "id": 16,
//                 "public_path": "https://book-sharing-app-api.onrender.com/storage/media/book/book_java_447769/book-1706603888_5088849b.pdf"
//             },
//             "user": {
//                 "id": 5,
//                 "name": "Myo Min Ko",
//                 "email": "adminmk@gmail.com",
//                 "profile": {
//                     "id": 19,
//                     "public_path": "https://book-sharing-app-api.onrender.com/storage/media/user/tmpphpnpadno/user-1706605242_a91ba615.jpg"
//                 },
//                 "description": null,
//                 "created_at": "15 hours ago"
//             },
//             "reactions": 0
//         }
//     ]
// }

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
    final response = await http.get(Uri.parse('$baseUrl/books'),
        headers: {'Accept': 'application/json'});
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
  static Future<Book> createBook(
      {required String userId,
      required String name,
      required String description,
      required String review,
      required File photo,
      required File book,
      required String status}) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/add-book'));
    request.fields.addAll({
      'user': userId,
      'name': name,
      'description': description,
      'review': review,
      'status': status
    });
    request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    request.files.add(await http.MultipartFile.fromPath('book', book.path));
    var response = await request.send();
    var responseData = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      var data = json.decode(responseData.body);
      Book book = Book.fromJson(data['data']);
      return book;
    } else {
      throw Exception('Failed to create book');
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
    final response = await http.put(Uri.parse('$baseUrl/update-book/$id'),
        headers: {'Accept': 'application/json'}, body: json.encode(data));
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
    final response = await http.delete(Uri.parse('$baseUrl/delete-book/$id'),
        headers: {'Accept': 'application/json'});
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

class User {
  String id;
  String name;
  String email;
  Profile profile;
  String? description;
  String createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profile,
    required this.description,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      profile: Profile.fromJson(json['profile']),
      description: json['description'],
      createdAt: json['created_at'],
    );
  }
}

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
