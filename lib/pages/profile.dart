import 'dart:io';
import 'dart:typed_data';
import 'package:book_sharing_app/model/user.dart';
import 'package:book_sharing_app/pages/cart.dart';
import 'package:book_sharing_app/widgets/input_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_sharing_app/controller/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _image;
  File? selectedImage;
  String? profileImage;
  User? user;
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('getting user');
    _setUserInfo();
  }

  _setUserInfo() async {
    final userData = await _authenticationController.getUser();

    setState(() {
      user = userData;
      profileImage = user?.profile?.public_path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading:   InkWell(
            onTap: (){
              Get.toNamed('/');
            },
            child:  const Icon(Icons.arrow_back)
        ),
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
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
              child: CircleAvatar(
                radius: 20,
                backgroundImage: profileImage != null
                    ? NetworkImage("$profileImage")
                    : NetworkImage("https://img6.arthub.ai/6497fccf-d831.webp"),
              ),
            ),
          ),
        ],
        toolbarHeight: kToolbarHeight + 20,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            foregroundImage: MemoryImage(_image!),
                            minRadius: 60.0,
                          )
                        : CircleAvatar(
                            foregroundImage: profileImage != null
                                ? NetworkImage("$profileImage")
                                : const NetworkImage(
                                    "https://img6.arthub.ai/6497fccf-d831.webp"),
                            minRadius: 60.0,
                          ),
                    Positioned(
                      bottom: -0,
                      left: 85,
                      child: CircleAvatar(
                        maxRadius: 16,
                        backgroundColor: Color(0xff94d500),
                        child: IconButton(
                          focusColor: Colors.greenAccent,
                          color: Colors.white,
                          iconSize: 16,
                          icon: const Icon(
                            Icons.edit_outlined,
                          ),
                          onPressed: () {
                            _pickImage();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user?.name ?? "",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const Padding(
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
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        user?.created_at ?? "",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Bio',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                user?.description ?? "",
                style: const TextStyle(fontSize: 12.0, color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            TabSection(
              setUserProfileInfo: _setUserInfo,
            )
          ],
        ),
      ),
    );
  }

  Future _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? returnImage =
        await picker.pickImage(source: ImageSource.gallery);
    //final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });

    final response = await _authenticationController.uploadProfile(
         id: "${user?.id}",
        image: File(returnImage.path)
    );
    print("we got the code like $response");
    if (response == 200) {
      _setUserInfo();
      Fluttertoast.showToast(
          msg: "Profile Uploaded Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}

class TabSection extends StatefulWidget {
  final VoidCallback setUserProfileInfo;

  const TabSection({super.key, required this.setUserProfileInfo});

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _descriptionController = TextEditingController();
  final AuthenticationController _authenticationController = Get.find();
  int? id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('getting user');
    _setUserInfo();
  }

  _setUserInfo() async {
    final user = await _authenticationController.getUser();

    setState(() {
      _nameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
      _passwordController.text =
          '';
      _oldPasswordController.text =
      '';// Assuming you don't want to display the password
      _descriptionController.text = user.description ?? '';
      id = user.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const TabBar(
              tabs: [

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Books"),
                      SizedBox(width: 5,),
                      Icon(Icons.book_rounded)
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Carts"),
                      SizedBox(width: 5,),
                      Icon(Icons.book_rounded)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Setting"),
                      SizedBox(width: 5,),
                      Icon(Icons.settings)
                    ],
                  ),
                )
              ],
              indicatorColor: Colors.green,
              labelColor: Colors.green,
            ),
            SizedBox(
              //Add this to give height
              height: MediaQuery.of(context).size.height,
              child: TabBarView(children: [
                Text("Articles Body"),
                Carts(),
                Column(
                  children: [
                    const SizedBox(height: 15.0,),
                    const Text('Profile Information',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.green
                    ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left:15.0,
                          right: 15.0
                      ),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Obx(() => InputFormWidget(
                                  controller: _nameController,
                                  hintText: "Name",
                                  validateText: _authenticationController
                                      .validationErrors['name'] ??
                                      '')),
                              Obx(() => InputFormWidget(
                                  controller: _emailController,
                                  hintText: "Email",
                                  validateText: _authenticationController
                                      .validationErrors['email'] ??
                                      '')),
                              InputFormWidget(
                                  controller: _descriptionController,
                                  hintText: "Description",
                                  maxLines: 3,
                                  minLines: 2,
                                  validateText: ""),
                              PrettyShadowButton(
                                label: "Pretty Shadow Button",
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {}
                                  final response =
                                  await _authenticationController.updateProfile(
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    description: _descriptionController.text.trim(),
                                    id: id,
                                  );
                                  print(response);
                                  if (response == 200) {
                                    _setUserInfo();
                                    widget.setUserProfileInfo();
                                  }
                                },
                                icon: Icons.arrow_forward,
                                shadowColor: Colors.green,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {}
                                  final response =
                                  await _authenticationController.updateProfile(
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    description: _descriptionController.text.trim(),
                                    id: id,
                                  );
                                  print(response);
                                  if (response == 200) {
                                    _setUserInfo();
                                    widget.setUserProfileInfo();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                ),
                                child: Obx(() {
                                  return _authenticationController.isLoading.value
                                      ? const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Processing'),
                                      SizedBox(width: 5.0),
                                      SizedBox(
                                        width: 15.0,
                                        height: 15.0,
                                        child: CircularProgressIndicator(
                                          color: Colors.green,
                                          strokeWidth: 3.0,
                                        ),
                                      ),
                                    ],
                                  )
                                      : const Text(
                                    "Update",
                                    style: TextStyle(color: Colors.green),
                                  );
                                }),
                              ),
                            ],
                          )),
                    ),
                    const Divider(
                      color: Colors.green,
                      thickness: 1,
                      height: 30.0,
                    ),
                    const Text('Change Password',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.green
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left:15.0,
                          right: 15.0
                      ),
                      child: Form(
                          key: _passwordFormKey,
                          child: Column(
                            children: [
                              Obx(() => InputFormWidget(
                                  controller: _passwordController,
                                  hintText: "Old Password",
                                  obscureText: true,
                                  validateText: _authenticationController
                                      .validationErrors['old_password'] ??
                                      '')),
                              Obx(() => InputFormWidget(
                                  controller: _oldPasswordController,
                                  hintText: "New Password",
                                  obscureText: true,
                                  validateText: _authenticationController
                                      .validationErrors['password'] ??
                                      '')),

                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {}
                                  final response =
                                  await _authenticationController.changePassword(
                                    password: _passwordController.text.trim(),
                                    oldPassword: _oldPasswordController.text.trim(),
                                    id: id,
                                  );
                                  print(response);
                                  if (response == 200) {
                                    _setUserInfo();
                                    widget.setUserProfileInfo();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                ),
                                child: Obx(() {
                                  return _authenticationController.isUpdating.value
                                      ? const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Processing'),
                                      SizedBox(width: 5.0),
                                      SizedBox(
                                        width: 15.0,
                                        height: 15.0,
                                        child: CircularProgressIndicator(
                                          color: Colors.green,
                                          strokeWidth: 3.0,
                                        ),
                                      ),
                                    ],
                                  )
                                      : const Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.green),
                                  );
                                }),
                              ),
                            ],
                          )),
                    ),

                    const Divider(
                      color: Colors.red,
                      thickness: 1,
                      height: 30.0,
                    ),
                    ElevatedButton(
                        onPressed: (){
                          _authenticationController.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)
                          )
                        ),
                        child: const SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                                "Logout",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold
                               ),
                            ),
                          ),
                        )
                    )
                  ],
                )

              ]),
            ),
          ],
        ),
      ),
    );
  }
}
