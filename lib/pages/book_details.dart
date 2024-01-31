import 'package:book_sharing_app/model/book.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readmore/readmore.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.author,
    required this.pdf,
  });

  final Photo image;
  final String title;
  final String description;
  final String author;
  final BookFile pdf;
  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  String fileUrl = "https://fluttercampus.com/sample.pdf";

  String content = "whkat byJoe NelsonMonday 22 rdfghjmkhgfdsadgtfhujhgfdsadrgthuioygtedsadgtyujhyhjgfdsadfgthyujgftdsadgtythe Continental League Cup on Wednesday before hosting Aston Villa in the WSL on Sunday rdfghjmkhgfdsadgtfhujhgfdsadrgthuioygtedsadgtyujhyhjgfdsadfgthyujgftdsadgtythe Continental League Cup on Wednesday before hosting Aston Villa in the WSL on Sunday  away tobefore hosting away to Manchester City in rdfghjmkhgfdsadgtfhujhgfdsadrgthuioygtedsadgtyujhyhjgfdsadfgthyujgftdsadgtythe Continental League Cup on Wednesday before hosting Aston Villa in the WSL on Sundayrdfghjmkhgfdsadgtfhujhgfdsadrgthuioygtedsadgtyujhyhjgfdsadfgthyujgftdsadgtythe Continental League Cup on Wednesday before hosting Aston Villa in the WSL on Sunday  rdfghjmkhgfdsadgtfhujhgfdsadrgthuioygtedsadgtyujhyhjgfdsadfgthyujgftdsadgtythe Continental League Cup on Wednesday before hosting Aston Villa in the WSL on Sunday.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.bookmark_add_outlined),
                onPressed: () {},
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
                          const Text(
                            "Authors",
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
                  child: Expanded(
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
