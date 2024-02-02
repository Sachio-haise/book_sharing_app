import 'dart:async';
import 'package:book_sharing_app/controller/auth_controller.dart';
import 'package:book_sharing_app/pages/profile.dart';
import 'package:book_sharing_app/widgets/books_list.dart';
import 'package:book_sharing_app/widgets/card_scroll.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeController = Get.put(HomeController());
  final pageController = PageController();
  int currentPageIndex = 0;
  final AuthenticationController _authenticationController = Get.put(AuthenticationController());
  String? _token;

  @override
  void initState() {
    super.initState();
    _homeController.loadToken();
  }

  Future setUserInfoNav() async {
    await _authenticationController.fetchUserData();
    print("authentication ${_authenticationController.user?.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: const Padding(
          padding: EdgeInsets.only(top: 6.0, left: 8.0, right: 8.0),
          child: Image(
            image: AssetImage('assets/images/logo_.png'),
          ),
        ),
        title: const Center(
            child: Text(
          'Book Library',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: InkWell(
              onTap: _homeController.authenticate,
              child: CircleAvatar(
                foregroundImage: _authenticationController.profileImage !=
                    null
                    ? NetworkImage(
                    "${_authenticationController.profileImage}")
                    : const NetworkImage(
                    "https://img6.arthub.ai/6497fccf-d831.webp"),
                minRadius: 18.0,
              ),
            ),
          )
        ],
        toolbarHeight: kToolbarHeight + 20,
      ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      const Text(
                        'Popular',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: _homeController.authenticate,
                        child: const Text(
                          'See All',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 285,
                child: CardRow(),
              ),

              //All Books
              Container(
                  // margin: const EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      const Text(
                        'All Books',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.book,
                        color: Colors.green,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          if (_token != null && _token!.isNotEmpty) {
                            Get.offAllNamed('/book_lists');
                          } else {
                            Get.toNamed('/auth');
                          }
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
              const Books()
            ],
          ),
          const ProfilePage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: Colors.green,
        onPressed: () async {
          final value = await _homeController.navigateToBookCreatePage();
          if (value != null || value) {
            _homeController.authenticate();
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green.shade50,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentPageIndex = 0;
                  pageController.animateToPage(
                    currentPageIndex,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                });
              },
              icon: Icon(
                Icons.home_rounded,
                color: currentPageIndex == 0 ? Colors.green : Colors.grey,
                size: currentPageIndex == 0
                    ? 30
                    : 26, // Increase icon size when selected
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     setState(() {
            //       currentPageIndex = 1;
            //     });
            //   },
            //   icon: Icon(
            //     Icons.search_outlined,
            //     color: currentPageIndex == 1 ? Colors.green : Colors.grey,
            //     size: currentPageIndex == 1
            //         ? 30
            //         : 24, // Increase icon size when selected
            //   ),
            // ),
            SizedBox(width: 48), // Empty space for the FAB
            // IconButton(
            //   onPressed: () {
            //     setState(() {
            //       currentPageIndex = 2;
            //     });
            //   },
            //   icon: Icon(
            //     Icons.menu_book_outlined,
            //     color: currentPageIndex == 2 ? Colors.green : Colors.grey,
            //     size: currentPageIndex == 2
            //         ? 30
            //         : 24, // Increase icon size when selected
            //   ),
            // ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentPageIndex = 1;
                  pageController.animateToPage(
                    currentPageIndex,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                });
              },
              icon: Icon(
                Icons.account_circle,
                color: currentPageIndex == 1 ? Colors.green : Colors.grey,
                size: currentPageIndex == 1
                    ? 30
                    : 26, // Increase icon size when selected
              ),
            ),
          ],
        ),
      ),
    );
  }
}
