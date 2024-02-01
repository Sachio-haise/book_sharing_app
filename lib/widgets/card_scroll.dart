import 'package:book_sharing_app/model/book.dart';
import 'package:book_sharing_app/pages/book_details.dart';
import 'package:book_sharing_app/widgets/reading_card_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/book_controller.dart';

class CardRow extends StatefulWidget {
  const CardRow({Key? key}) : super(key: key);

  @override
  State<CardRow> createState() => _CardRowState();
}

class _CardRowState extends State<CardRow> {
  final _bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    final books = _bookController.books;
    return Obx(() {
      if (books.isEmpty) {
        return const Center(child: Text('No Popular Books!'));
      }
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          Book book = books[index];
          return ReadingListCard(
            image: book.photo.publicPath,
            title: book.name,
            auth: book.user.name ?? "",
            rating: book.reactions,
            pressDetails: () {
              //go to book details page
              Navigator.pushNamed(context, '/book_details', arguments: book);
              Get.to(BookDetails(
                id: book.id,
                image: book.photo,
                title: book.name,
                description: book.description,
                author: book.user.name ?? "",
                pdf: book.book,
              ));
            },
            pressRead: () {
              // Handle press read
            },
          );
        },
      );
    });
  }
}
