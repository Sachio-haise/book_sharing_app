import 'dart:convert';

import 'package:book_sharing_app/controller/auth_controller.dart';
import 'package:book_sharing_app/controller/book_controller.dart';
import 'package:book_sharing_app/model/book.dart';
import 'package:book_sharing_app/model/user.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.author,
    required this.pdf,
  });

  final Photo image;
  final String id;
  final String title;
  final String description;
  final String author;
  final BookFile pdf;
  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  String fileUrl = "https://fluttercampus.com/sample.pdf";
  final AuthenticationController _authenticationController = Get.put(AuthenticationController());
  final BookController _bookController = Get.put(BookController());
  String? _token;
  User? user;
  bool isInCart = false;
  String? profileImage;

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
      profileImage = user?.profile?.public_path;
    });

    print("we got user - > ${user?.name}");
    if(user != null) await _getBookInfo();
  }

  Future _getBookInfo() async {
    final bookInfo = await _bookController.getBookInfo(bookId:widget.id, userId: "${user?.id}");
    print("This is book info ${bookInfo['isInCart']}");
      setState(() {
        isInCart = bookInfo['isInCart'];
      });

  }


  Future _saveBook () async{
    setState(() {
      isInCart = !isInCart;
    });
    final res = await _bookController.saveBook(userId: "${user?.id}", bookId: widget.id);
    await _getBookInfo();
    print("this is book info $res");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: isInCart ? const Icon(Icons.bookmark) : const Icon(Icons.bookmark_add_outlined),
                onPressed: () {
                  _token != null ? _saveBook() : Get.toNamed('/auth');
                },
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //for book profile picture
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Adjust the border radius as needed
                  child: Image.network(
                    widget.image.publicPath,
                    width: 300,
                    height: 350,
                    fit: BoxFit.cover, // Optional, to cover the entire container
                  ),
                ),
              ),
            ),
            //for Book title document
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, left: 24),
              child: Text(
                widget.title,
                style:const TextStyle(
                    color: Color(0xFF252435),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),

            //book details ratting,author,discription
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF2EC05E),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Authors ${user?.id}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            widget.author,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          )
                        ],
                      ),

                      const Column(
                        children: [
                          Text(
                            "Like",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            "140",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),

            //button three in a row

            //Text body book
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(left:24.0,right: 24.0),
                child: SizedBox(
                  child: ReadMoreText(
                    "${widget.description} .'This is a msg from AKM.Try To Download this pdf to save in the user phoen'. ${widget.pdf.publicPath}" ,
                    trimLines: 5,
                    textAlign: TextAlign.justify,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: "Read More",
                    trimExpandedText: "Show Less",
                    lessStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    moreStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252435),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 140.0,
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left:28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Divider(),
            SizedBox(
              width: double.infinity,
              child:    FilledButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF2EC05E)),
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                onPressed: () async {
                  Map<Permission, PermissionStatus> statuses =
                  await [Permission.storage].request();
                  if (statuses[Permission.storage]!.isGranted) {
                    var dir =
                    await DownloadsPathProvider.downloadsDirectory;
                    if (dir != null) {
                      String saveName = "file.pdf";
                      String savePath = dir.path + "/$saveName";
                      print(savePath);
                      try {
                        await Dio().download(fileUrl, savePath,
                            onReceiveProgress: (received, total) {
                              if (total != -1) {
                                print((received / total * 100)
                                    .toStringAsFixed(0) +
                                    "%");
                              }
                            });
                        print("File is saved to download folder: ");
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("File Downloaded")));
                      } on DioException catch (e) {
                        print(e.message);
                      }
                    }
                  } else {
                    print("No Permission to read and write");
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Permission Denied")));
                  }
                },
                child: const Text(
                  "Download PDF",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
