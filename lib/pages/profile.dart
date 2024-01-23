import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/logo_.png'),
                width: 30.0,
                height: 30.0,
              ),
              Text(
                'Book Library',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: InkWell(
              onTap: () {
                Get.toNamed('/profile');
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage:
                NetworkImage("https://img6.arthub.ai/6497fccf-d831.webp"),
              ),
            ),
          ),
        ],
        toolbarHeight: kToolbarHeight + 20,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  foregroundImage:
                  NetworkImage("https://img6.arthub.ai/6497fccf-d831.webp"),
                  minRadius: 60.0,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'David Robinson',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'joined',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '1 day ago',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top:8.0),
              child: Text('Bio',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold
                ),),
            ),
            Padding(
              padding: EdgeInsets.only(left:8.0,right: 8.0),
              child: Text('This is profile description This is profile'
                  ' description This is profile description This is profile description',
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            TabSection()

          ],
        ),
      ),
    );
  }
}

class TabSection extends StatelessWidget {
  const TabSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.only(left:15.0,right: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const TabBar(tabs: [
              Tab(text: "Profile",),
              Tab(text: "Books"),
            ],
            indicatorColor: Colors.green,
              labelColor: Colors.green,
            ),
            SizedBox(
              //Add this to give height
              height: MediaQuery.of(context).size.height,
              child: const TabBarView(children: [
                Column(
                  children: [

                  ],
                ),
                Text("Articles Body")
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

