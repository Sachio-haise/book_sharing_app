import 'dart:async';

import 'package:book_sharing_app/controller/auth_controller.dart';
import 'package:book_sharing_app/pages/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    setState(() {
      _token = token; // No need for null check here
    });
    print("token is $token");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: const Padding(
          padding: EdgeInsets.only(top:6.0,left: 8.0,right: 8.0),
          child: Image(
            image: AssetImage('assets/images/logo_.png'),
          ),
        ),
        title:  const Center(
            child: Text('Book Library',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold
              ),)),
        actions:  [
          Padding(
            padding:const EdgeInsets.only(right: 16.0,top: 8.0),
            child: InkWell(
              onTap: () {
                if (_token != null && _token!.isNotEmpty) {
                  Get.offAllNamed('/profile');
                } else {
                  Get.toNamed('/auth');
                }
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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index){
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.greenAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
              selectedIcon: Icon(Icons.add_circle),
              icon: Icon(Icons.add_circle_outline),
              label: 'Add Book'
          ),
          NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home'
          ),
          NavigationDestination(
              selectedIcon: Icon(Icons.account_circle),
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile'
          ),
        ],
      ),

    );
  }

}
