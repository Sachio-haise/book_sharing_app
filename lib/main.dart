import 'package:book_sharing_app/pages/home.dart';
import 'package:book_sharing_app/pages/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Let's Share Books",
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.zoom,
      initialRoute: "/",
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/auth', page: () => AuthPage()),
      ],
    );
  }
}

