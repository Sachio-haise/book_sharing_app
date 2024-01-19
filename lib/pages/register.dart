import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        // leading: const Padding(
        //   padding: EdgeInsets.only(top:6.0,left: 8.0,right: 8.0),
        //   child: Image(
        //     image: AssetImage('assets/images/logo_.png'),
        //   ),
        // ),
        title:
        const Center(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/logo_.png'),
                  width: 30.0,
                  height: 30.0,
                ),
                Text('Book Library',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                  ),),
              ],
            )
            ),
        actions:  [
          Padding(
            padding:const EdgeInsets.only(right: 16.0,top: 8.0),
            child: InkWell(
              onTap: () {
                Get.to(RegisterPage());
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    "https://img6.arthub.ai/6497fccf-d831.webp"
                ),
              ),
            ),
          )
        ],
        toolbarHeight: kToolbarHeight + 20,
      ),
      body: Column(
        children: [
          const Center(
            child:
              Text(
                'SIGN UP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0
                ),
              ),
          ),
          Container(
            color: Colors.grey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: "Enter product name"),
                  validator: (value) => value != null && value.isEmpty
                      ? 'Fill the product name'
                      : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Enter product price"),
                  validator: (value) => value != null && value.isEmpty
                      ? 'Fill the product price'
                      : value != null && double.tryParse(value) == null ?
                  "Fill only number" : null,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
