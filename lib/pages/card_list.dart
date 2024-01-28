import 'package:flutter/material.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({super.key});

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  String amount="54.69";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card"),
      ),
      body: Column(
        children: [
          Container(
            width: 500,
            height: 150,

            decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Container(
                    width: 100,
                    height: 130,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child:
                    Padding(padding: const EdgeInsets.all(5),
                      child:Image.network("https://picsum.photos/250?image=9",width: 80,height: 100,),
                    )
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Beyond the shadows",style: TextStyle(fontWeight: FontWeight.bold),),
                    Text("Anna Hub",style: TextStyle(fontWeight: FontWeight.normal),),
                    Row(
                      children: [
                        Icon(Icons.star),
                        Icon(Icons.star_half),
                        Icon(Icons.star_border_outlined),
                        Icon(Icons.star_half),
                        Icon(Icons.star_border),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [const Row(
                    children: [SizedBox(width: 50,),
                      // IconButton(onPressed:(){
                      //
                      // }, icon:
                      Icon(Icons.exit_to_app,textDirection: TextDirection.rtl,),
                    ],
                  ),
                    const SizedBox(height: 20,),
                    Text(amount,style: const TextStyle(fontWeight: FontWeight.bold),),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
