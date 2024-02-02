import 'package:book_sharing_app/controller/book_controller.dart';
import 'package:flutter/material.dart';
import 'package:book_sharing_app/model/book.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/auth_controller.dart';
import '../model/user.dart';

class Carts extends StatefulWidget {
  const Carts({
    Key? key
  }) : super(key: key);

  @override
  State<Carts> createState() => _BooksState();
}

class _BooksState extends State<Carts> {
  List<Book> books = [];
  final BookController _bookController = Get.put(BookController());
  final AuthenticationController _authenticationController = Get.put(AuthenticationController());
  String? _token;
  User? user;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _setUserInfo();
  }

  Future<void> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    setState(() {
      _token = token; // No need for null check here
    });

  }
  _setUserInfo() async {
    final userData = await _authenticationController.getUser();
    setState(() {
      user = userData;
    });
    if(user != null) await loadBooks();
  }

  Future<void> loadBooks() async {
    List<Book> fetchedBooks = await _bookController.getCarts(userId: "${user?.id}");
    setState(() {
      books = fetchedBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(books[index].photo.publicPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            books[index].name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            books[index].user.name ?? "",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            books[index].description.length > 25
                                ? books[index].description.substring(0, 25) +
                                '....'
                                : books[index].description,
                            style: const TextStyle(
                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding:  const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                              Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
  }
}
