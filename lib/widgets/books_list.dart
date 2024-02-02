import 'package:book_sharing_app/controller/auth_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:book_sharing_app/model/book.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../controller/book_controller.dart';
import '../pages/book_details.dart';

class Books extends StatefulWidget {
  const Books({Key? key}) : super(key: key);

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  final _bookController = Get.put(BookController());
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bookController.loadBooks(load: true);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          itemCount: _bookController.books.length,
          itemBuilder: (BuildContext context, int index) {
            final book = _bookController.books[index];
            return Item(book: book);
          },
        ),
      );
    });
  }
}

class Item extends StatefulWidget {
  const Item({super.key, required this.book});

  final Book book;

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  final _bookController = Get.put(BookController());
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  bool isReact = false;
  bool loading = false;
  int tmpCount = 0;

  @override
  void initState() {
    super.initState();
  }

  Future _reactBook({required bookId}) async {
    if (loading || _authenticationController.user?.id == null) return;

    loading = true;
    final res = await _bookController.reactBook(
        userId: "${_authenticationController.user?.id}", bookId: bookId);
    await _bookController.loadBooks(load: false);
    print("this is book info $res");
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.book.photo.publicPath,
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) {
                    return Container(
                      color: Colors.red.shade100,
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      widget.book.user.profile?.public_path != null
                          ? CircleAvatar(
                              foregroundImage: NetworkImage(
                                  "${widget.book.user.profile?.public_path}"),
                              minRadius: 10.0,
                            )
                          : const Icon(Icons.account_circle, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        widget.book.user.name ?? "",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.book.description.length > 25
                        ? widget.book.description.substring(0, 25) + '....'
                        : widget.book.description,
                    style: const TextStyle(
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _authenticationController.user != null
                            ? widget.book.carts.contains(
                                    _authenticationController.user?.id)
                                ? IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.bookmark),
                                    color: Colors.deepOrange,
                                  )
                                : IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.bookmark_outline),
                                    color: Colors.deepOrange,
                                  )
                            : IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.bookmark_outline),
                                color: Colors.deepOrange,
                              ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            _authenticationController.user != null
                                ? widget.book.react_user.contains(
                                        _authenticationController.user?.id)
                                    ? IconButton(
                                        onPressed: () {
                                          _reactBook(bookId: widget.book.id);
                                        },
                                        icon: const Icon(Icons.favorite),
                                        color: Colors.deepOrange,
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          _reactBook(bookId: widget.book.id);
                                        },
                                        icon: const Icon(
                                            Icons.favorite_border_outlined),
                                        color: Colors.deepOrange,
                                      )
                                : IconButton(
                                    onPressed: () {
                                      _reactBook(bookId: widget.book.id);
                                    },
                                    icon: const Icon(
                                        Icons.favorite_border_outlined),
                                    color: Colors.deepOrange,
                                  ),
                            Positioned(
                                bottom: 10,
                                right: 12,
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.green[300]),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3.0, right: 3.0),
                                      child: Text(
                                        "${widget.book.reactions + tmpCount}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 8),
                                      ),
                                    )))
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton.tonal(
                          onPressed: () {
                            // go to book details page
                            // Navigator.pushNamed(
                            //     context, '/book_details',
                            //     arguments: book);
                            Get.to(BookDetails(
                                id: widget.book.id,
                                image: widget.book.photo,
                                title: widget.book.name,
                                description: widget.book.description,
                                author: widget.book.user.name ?? "",
                                pdf: widget.book.book,
                                authorProfile:
                                    widget.book.user.profile?.public_path ??
                                        ""));
                          },
                          child: const Text('Details')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
