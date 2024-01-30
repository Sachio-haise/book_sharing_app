import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readmore/readmore.dart';

void main() {
  runApp(const BookDetails());
}

class BookDetails extends StatefulWidget {
  const BookDetails({super.key});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  String authorName="C.S.Luwis";
  String ratting='4.9/5';
  String fileUrl = "https://fluttercampus.com/sample.pdf";

  String content = "byJoe NelsonMonday 22   away tobefore hosting away to Manchester City in the Continental League Cup on Wednesday before hosting Aston Villa in the WSL on Sunday.";
  String networkImg="https://picsum.photos/250?image=9";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[200],
          leading: const Icon(Icons.arrow_back),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {},
                ))
          ],
        ),
        body: Column(
          children: [
            Center(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.network(
                    networkImg,
                    width: 100,
                    height: 150,
                  ),
                )),
            const SizedBox(
              height: 2,
            ),
            const Padding(padding: EdgeInsets.only(left: 20)),
            const Center(
              child: Expanded(
                child: Text(
                  "The Skittering and Other Tales",
                  style: TextStyle(
                      color: Color(0xFF252435),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 350,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Authors",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'authorName',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Ratting",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'ratting',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Read",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "5.3K",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Page",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "320",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),

                      //button row
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF2EC05E)),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)))),
                    onPressed: () {},
                    child: const Text("Description"),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: OutlinedButton(
                      style: ButtonStyle(
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)))),
                      onPressed: () {},
                      child: const Text("Reviews")),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: OutlinedButton(
                      style: ButtonStyle(
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)))),
                      onPressed: () {},
                      child: const Text("Instruction")),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 350,
                  child: Expanded(
                    child: ReadMoreText(
                      content,
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
              height: 400,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Divider(),
                Center(
                  child: FilledButton(
                    style: ButtonStyle(
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)))),
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
                                SnackBar(content: Text("File Downloaded")));
                          } on DioError catch (e) {
                            print(e.message);
                          }
                        }
                      } else {
                        print("No Permission to read and write");
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Permission Denied")));
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
            const SizedBox(
              height: 3,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: OutlinedButton(
                      style: ButtonStyle(
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)))),
                      onPressed: () {},
                      child: const Text("Read Sample")),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FilledButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF2EC05E)),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)))),
                      onPressed: () {},
                      child: const Text("Buy Now")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
