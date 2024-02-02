import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:book_sharing_app/model/book.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../controller/book_controller.dart';
import '../pages/book_details.dart';

class Books extends StatefulWidget {
  const Books({Key? key}) : super(key: key);

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  final _bookController = Get.put(BookController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bookController.loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          itemCount: _bookController.books.length,
          itemBuilder: (BuildContext context, int index) {
            final book = _bookController.books[index];
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
                          imageUrl: book.photo.publicPath,
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
                            book.name,
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
                              const Icon(Icons.account_circle, size: 18),
                              const SizedBox(width: 10),
                              Text(
                                book.user.name ?? "",
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
                            book.description.length > 25
                                ? book.description.substring(0, 25) + '....'
                                : book.description,
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
                                child: IconButton(
                                  onPressed: () {
                                    // Add to Bookmark button logic
                                    // Implement your logic here
                                  },
                                  icon: const Icon(Icons.bookmark),
                                  color: Colors.deepOrange,
                                ),
                              ),
                              const SizedBox(width: 10),
                              FilledButton.tonal(
                                  onPressed: () {
                                    //go to book details page
                                    Navigator.pushNamed(
                                        context, '/book_details',
                                        arguments: book);
                                    Get.to(BookDetails(
                                      id: book.id,
                                      image: book.photo,
                                      title: book.name,
                                      description: book.description,
                                      author: book.user.name ?? "",
                                      pdf: book.book,
                                    ));
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
          },
        ),
      );
    });
  }
}
