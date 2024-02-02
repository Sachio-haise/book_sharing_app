import 'dart:io';
import 'dart:typed_data';
import 'package:book_sharing_app/controller/book_controller.dart';
import 'package:book_sharing_app/model/user.dart';
import 'package:book_sharing_app/pages/cart.dart';
import 'package:book_sharing_app/widgets/input_form_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_sharing_app/controller/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/book.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _image;
  File? selectedImage;

  final AuthenticationController _authenticationController =
  Get.put(AuthenticationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUserInfo();
  }

  _setUserInfo() async {
    await _authenticationController.fetchUserData();
    print("authentication ${_authenticationController.user?.name}");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(builder: (context) {
      return SingleChildScrollView(
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
                      foregroundImage: _authenticationController.profileImage !=
                          null
                          ? NetworkImage(
                          "${_authenticationController.profileImage}")
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
                      _authenticationController.user?.name ?? "",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
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
                        _authenticationController.user?.created_at ?? "",
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
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                _authenticationController.user?.description ?? "",
                style: const TextStyle(fontSize: 12.0, color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Flexible(
              child: SizedBox(
                child: TabSection(
                  setUserProfileInfo: _setUserInfo,
                ),
              ),
            )
          ],
        ),
      );
    });
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
        id: "${_authenticationController.user?.id}",
        image: File(returnImage.path));
    print("we got the code like $response");
    if (response == 200) {
      _setUserInfo();
      Fluttertoast.showToast(
          msg: "Profile Uploaded Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
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
      _passwordController.text = '';
      _oldPasswordController.text =
      ''; // Assuming you don't want to display the password
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
                      Text("My Books"),
                      SizedBox(
                        width: 5,
                      ),
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
                      Text("Saved Books"),
                      SizedBox(
                        width: 5,
                      ),
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
                      SizedBox(
                        width: 5,
                      ),
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
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: TabBarView(children: [
                ManageBooks(),
                SavedBooks(),
                Column(
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                      'Profile Information',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.green),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Obx(() =>
                                  InputFormWidget(
                                      controller: _nameController,
                                      hintText: "Name",
                                      validateText: _authenticationController
                                          .validationErrors['name'] ??
                                          '')),
                              Obx(() =>
                                  InputFormWidget(
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
                              // PrettyShadowButton(
                              //   label: "Pretty Shadow Button",
                              //   onPressed: () async {
                              //     if (_formKey.currentState!.validate()) {}
                              //     final response =
                              //         await _authenticationController
                              //             .updateProfile(
                              //       name: _nameController.text.trim(),
                              //       email: _emailController.text.trim(),
                              //       description:
                              //           _descriptionController.text.trim(),
                              //       id: id,
                              //     );
                              //     print(response);
                              //     if (response == 200) {
                              //       _setUserInfo();
                              //       widget.setUserProfileInfo();
                              //     }
                              //   },
                              //   icon: Icons.arrow_forward,
                              //   shadowColor: Colors.green,
                              // ),
                              SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {}
                                    final response =
                                    await _authenticationController
                                        .updateProfile(
                                      name: _nameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      description:
                                      _descriptionController.text.trim(),
                                      id: id,
                                    );
                                    Fluttertoast.showToast(
                                        msg: "Profile Updated Successfully!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);

                                    if (response == 200) {
                                      _setUserInfo();
                                      widget.setUserProfileInfo();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.green,
                                  ),
                                  child: Obx(() {
                                    return _authenticationController
                                        .isLoading.value
                                        ? const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Processing'),
                                        SizedBox(width: 5.0),
                                        SizedBox(
                                          width: 15.0,
                                          height: 15.0,
                                          child:
                                          CircularProgressIndicator(
                                            color: Colors.green,
                                            strokeWidth: 3.0,
                                          ),
                                        ),
                                      ],
                                    )
                                        : const Text(
                                      "Update",
                                      style:
                                      TextStyle(color: Colors.green),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          )),
                    ),
                    const Divider(
                      color: Colors.green,
                      thickness: 1,
                      height: 30.0,
                    ),
                    const Text(
                      'Change Password',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.green),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Form(
                          key: _passwordFormKey,
                          child: Column(
                            children: [
                              Obx(() =>
                                  InputFormWidget(
                                      controller: _passwordController,
                                      hintText: "Old Password",
                                      obscureText: true,
                                      validateText: _authenticationController
                                          .validationErrors['old_password'] ??
                                          '')),
                              Obx(() =>
                                  InputFormWidget(
                                      controller: _oldPasswordController,
                                      hintText: "New Password",
                                      obscureText: true,
                                      validateText: _authenticationController
                                          .validationErrors['password'] ??
                                          '')),
                              SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {}
                                    final response =
                                    await _authenticationController
                                        .changePassword(
                                      password: _passwordController.text.trim(),
                                      oldPassword:
                                      _oldPasswordController.text.trim(),
                                      id: id,
                                    );
                                    Fluttertoast.showToast(
                                        msg: "Password Changed Successfully!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    if (response == 200) {
                                      _setUserInfo();
                                      widget.setUserProfileInfo();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.green,
                                  ),
                                  child: Obx(() {
                                    return _authenticationController
                                        .isUpdating.value
                                        ? const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Processing'),
                                        SizedBox(width: 5.0),
                                        SizedBox(
                                          width: 15.0,
                                          height: 15.0,
                                          child:
                                          CircularProgressIndicator(
                                            color: Colors.green,
                                            strokeWidth: 3.0,
                                          ),
                                        ),
                                      ],
                                    )
                                        : const Text(
                                      "Confirm",
                                      style:
                                      TextStyle(color: Colors.green),
                                    );
                                  }),
                                ),
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
                        onPressed: () {
                          _authenticationController.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red[600],
                        ),
                        child: const SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageBooks extends StatefulWidget {
  const ManageBooks({
    super.key,
  });

  @override
  State<ManageBooks> createState() => _ManageBooksState();
}

class _ManageBooksState extends State<ManageBooks> {
  final _authController = Get.find<AuthenticationController>();

  final _bookController = Get.find<BookController>();

  @override
  void initState() {
    super.initState();
    findBooksByAuthor();
  }

  findBooksByAuthor() {
    _bookController.findBooksByAuthor(_authController.user?.name ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: ListView.builder(
          itemCount: _bookController.bookByAuthor.length,
          itemBuilder: (BuildContext context, int index) {
            final book = _bookController.bookByAuthor[index];
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 20.0, left: 20.0, right: 20.0),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: book.photo.publicPath,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) {
                                    return Container(
                                      color: Colors.red.shade100,
                                      child: const Center(
                                        child: Icon(
                                            Icons.error, color: Colors.red),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                          Icons.account_circle, size: 18),
                                      const SizedBox(width: 10),
                                      Text(
                                        book.user.name ?? "",
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    book.description.length > 25
                                        ? book.description.substring(0, 25) +
                                        '....'
                                        : book.description,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          _bookController.deleteBook(
                              book.id, _authController.user?.name ?? '', context
                          );
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                      )
                    ],
                  ),

                ),
              ],
            );
          },
        ),
      );
    });
  }
}

class SavedBooks extends StatefulWidget {
  const SavedBooks({
    super.key,
  });

  @override
  State<SavedBooks> createState() => _SavedBooksState();
}

class _SavedBooksState extends State<SavedBooks> {
  final _authController = Get.find<AuthenticationController>();
  final _bookController = Get.find<BookController>();

  @override
  void initState() {
    super.initState();
    findBooksByAuthor();
  }

  findBooksByAuthor() {
    print("This is the user id ${_authController.user?.id}");
    _bookController.loadCart(userId: "${_authController.user?.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return
        ListView.builder(
          itemCount: _bookController.carts.length,
          itemBuilder: (BuildContext context, int index) {
            final book = _bookController.carts[index];
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 20.0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: book.photo.publicPath,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) {
                                  return Container(
                                    color: Colors.red.shade100,
                                    child: const Center(
                                      child: Icon(
                                          Icons.error, color: Colors.red),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.name,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.account_circle, size: 18),
                                    const SizedBox(width: 10),
                                    Text(
                                      book.user.name ?? "",
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  book.description.length > 25
                                      ? book.description.substring(0, 25) +
                                      '....'
                                      : book.description,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        _bookController.removeFromCart(
                            book.id, "${_authController.user?.id }", context
                        );
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                    )
                  ],
                ),

              ),
            );

            //   Container(
            //   margin: const EdgeInsets.all(4.0),
            //   padding: const EdgeInsets.all(8.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(12),
            //     color: Colors.green.shade50,
            //   ),
            //   child:  Container(
            //     margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            //     padding: const EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //       color: Colors.grey[100],
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Column(
            //       children: [
            //         Row(
            //           children: [
            //             ClipRRect(
            //               borderRadius: BorderRadius.circular(10),
            //               child: CachedNetworkImage(
            //                 imageUrl: book.photo.publicPath,
            //                 width: 100,
            //                 height: 150,
            //                 fit: BoxFit.cover,
            //                 errorWidget: (_, __, ___) {
            //                   return Container(
            //                     color: Colors.red.shade100,
            //                     child: const Center(
            //                       child: Icon(Icons.error, color: Colors.red),
            //                     ),
            //                   );
            //                 },
            //               ),
            //             ),
            //             const SizedBox(
            //               width: 10,
            //             ),
            //             Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   book.name,
            //                   style: const TextStyle(
            //                       color: Colors.black,
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.bold),
            //                 ),
            //                 const SizedBox(
            //                   height: 5,
            //                 ),
            //                 Row(
            //                   children: [
            //                     const Icon(Icons.account_circle, size: 18),
            //                     const SizedBox(width: 10),
            //                     Text(
            //                       book.user.name ?? "",
            //                       style: const TextStyle(
            //                           color: Colors.grey,
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.bold),
            //                     ),
            //                   ],
            //                 ),
            //                 const SizedBox(
            //                   height: 5,
            //                 ),
            //                 Text(
            //                   book.description.length > 25
            //                       ? book.description.substring(0, 25) + '....'
            //                       : book.description,
            //                   style: const TextStyle(
            //                     color: Colors.grey,
            //                     overflow: TextOverflow.ellipsis,
            //                   ),
            //                 ),
            //                 const SizedBox(
            //                   height: 10,
            //                 ),
            //                 Row(
            //                   children: [
            //                     Container(
            //                       decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(10),
            //                       ),
            //                       child: IconButton(
            //                         onPressed: () {
            //                           // Add to Bookmark button logic
            //                           // Implement your logic here
            //                         },
            //                         icon: const Icon(Icons.bookmark),
            //                         color: Colors.deepOrange,
            //                       ),
            //                     ),
            //                     const SizedBox(width: 10),
            //                     FilledButton.tonal(
            //                         onPressed: () {
            //                           // go to book details page
            //                           // Navigator.pushNamed(
            //                           //     context, '/book_details',
            //                           //     arguments: book);
            //                           Get.to(BookDetails(
            //                             id: book.id,
            //                             image: book.photo,
            //                             title: book.name,
            //                             description: book.description,
            //                             author: book.user.name ?? "",
            //                             pdf: book.book,
            //                           ));
            //                         },
            //                         child: const Text('Details')),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Text(
            //         book.name,
            //         style: const TextStyle(fontWeight: FontWeight.w700),
            //         maxLines: 6,
            //       ),
            //       Text(
            //         book.description,
            //         maxLines: 3,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //       Align(
            //         alignment: Alignment.bottomRight,
            //         child: InkWell(
            //           onTap: () {
            //             _bookController.deleteBook(
            //                 book.id, _authController.user?.name ?? '', context
            //             );
            //           },
            //           child: const Icon(
            //             Icons.delete,
            //             color: Colors.red,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // );
          },
        );
    });
  }
}
