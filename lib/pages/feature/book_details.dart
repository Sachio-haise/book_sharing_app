
import 'package:flutter/material.dart';
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
  String content =
      "byJoe NelsonMonday 22   away tobefore hosting away to Manchester City in the Continental League Cup on Wednesday before hosting Aston Villa in the WSL on Sunday.";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(icon: const Icon(Icons.save), onPressed: () {  },)
            )
          ],
        ),
        body: Column(
          children: [
            const Center(
              child: Image(
                width: 200,
                height: 300,
                image: AssetImage('assets/anime.jpeg'),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            const Padding(padding: EdgeInsets.only(left: 20)),
            const Center(
              child: Text(
                "The Skittering and Other Tales",
                style: TextStyle(
                    color: Color(0xFF252435),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            Center(
              child: Container(
                width: 350,
                height: 50,

                decoration: const BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Authors"),
                          Text(
                            "C.S.Luwis",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("Ratting"),
                          Text(
                            "4.9/5",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("Read"),
                          Text(
                            "5.3K",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("Page"),
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

                    style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF2EC05E)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>
                          (RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)))),

                    onPressed: () {},
                    child: const Text("Description"),
                  ),
                ),
                const SizedBox(width: 8,),

                Expanded(
                  child: OutlinedButton(

                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>
                            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)))),
                      onPressed: () {},
                      child: const Text("Reviews")),
                ),
                const SizedBox(width: 8,),
                Expanded(
                  child: OutlinedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>
                            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)))),
                      onPressed: () {},
                      child: const Text("Instruction")),
                )
              ],
            ),
            const SizedBox(
              height: 15,

            ),
            Center(
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
            const SizedBox(
              height: 200,
            ),
            Row(

              crossAxisAlignment: CrossAxisAlignment.end,

              children: [


                Expanded(
                  child: OutlinedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>
                            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)))),
                      onPressed: () {},
                      child: const Text("Read Sample")),
                ),
                const SizedBox(width: 10,),

                Expanded(
                  child: FilledButton(
                      style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF2EC05E)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>
                            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)))),

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
