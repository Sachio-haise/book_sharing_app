import 'package:book_sharing_app/model/book.dart';
import 'package:book_sharing_app/pages/book_details.dart';
import 'package:book_sharing_app/widgets/reading_card_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardRow extends StatefulWidget {
  const CardRow({Key? key}) : super(key: key);

  @override
  State<CardRow> createState() => _CardRowState();
}

class _CardRowState extends State<CardRow> {
  Future<List<Book>> _getBooks() async {
    // Make API call to get all books
    List<Book> books = await Book.getAllBooks();
    return books;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _getBooks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Book> books = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              Book book = books[index];
              return ReadingListCard(
                image: book.photo.publicPath,
                title: book.name,
                auth: book.user.name,
                rating: book.reactions,
                pressDetails: () {
                  //go to book details page
                  Navigator.pushNamed(context, '/book_details',
                      arguments: book);
                  Get.to(BookDetails(image: book.photo, title: book.name, description: book.description, author: book.user.name , pdf: book.book,));
                },
                pressRead: () {
                  // Handle press read
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
