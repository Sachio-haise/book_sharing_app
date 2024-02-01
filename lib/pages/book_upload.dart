import 'dart:io';
import 'package:book_sharing_app/model/book.dart';
import 'package:book_sharing_app/model/user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_sharing_app/controller/auth_controller.dart';

class BookCreatePage extends StatefulWidget {
  const BookCreatePage({Key? key}) : super(key: key);

  @override
  State<BookCreatePage> createState() => _BookCreatePageState();
}

class _BookCreatePageState extends State<BookCreatePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  String? profileImage;
  File? _photo;
  File? _book;
  int? status = 0; // 0 for private, 1 for public
  User? user;
  var token;

  @override
  void initState() {
    super.initState();
    _getTokenFromRoute();
    _setUserInfo();
  }

  void _getTokenFromRoute() {
    token = Get.arguments;
  }

  Future<void> _uploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
        print(_photo);
      });
    }
  }

  _setUserInfo() async {
    final userData = await _authenticationController.getUser();

    setState(() {
      user = userData;
      profileImage = user?.profile?.public_path;
    });
  }

  Future<void> _uploadBook() async {
    final filePicker = FilePicker.platform;
    final pickedFile = await filePicker
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (pickedFile != null) {
      setState(() {
        _book = File(pickedFile.files.single.path!);
        print(_book);
      });
    }
  }

  _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Book uploaded successfully!',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.green.shade100,
      ),
    );
  }

  _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Error occurred!',
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.red.shade100,
      ),
    );
  }

  Future<void> _uploadBookFile(BuildContext context) async {
    //apicall
    try {
      final res = await Book.createBook(
          userId: user!.id.toString(),
          name: nameController.text,
          description: descriptionController.text,
          review: reviewController.text,
          photo: _photo!,
          book: _book!,
          status: status.toString());
      if (res != null) {
        _showSuccessSnackBar(context);
      }
      print("we got the result ${res}");
    } catch (e) {
      _showErrorSnackBar(context);
      print(e);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[200],
          centerTitle: true,
          title: const Text('Book Upload'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back(result: true);
              })),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_circle),
                    const SizedBox(width: 10),
                    Text(
                      user?.name ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              TextFormField(
                controller: reviewController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Review',
                ),
              ),
              GestureDetector(
                onTap: _uploadPhoto,
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    height: 150,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey, // Set border color to grey
                        style: BorderStyle.solid, // Set border style to dashed
                      ),
                    ),
                    child: _photo != null
                        ? Image.file(
                            _photo!,
                            height: 200,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: _uploadPhoto,
                                  icon: const Icon(Icons.image_rounded)),
                              const Text('Upload Book Photo'),
                            ],
                          )),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Implement showing the selected book file
                  if (_book != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Selected Book'),
                          content: Image.file(_book!),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  height: 100,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey, // Set border color to grey
                      style: BorderStyle.solid, // Set border style to dashed
                    ),
                  ),
                  child: _book != null
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.menu_book_outlined),
                            Text(_book!.path.split('/').last),
                          ],
                        ))
                      : Column(
                          children: [
                            IconButton(
                                onPressed: _uploadBook,
                                icon: const Icon(Icons.add)),
                            const Text('Upload Book PDF'),
                          ],
                        ),
                ),
              ),
              ListTile(
                title: const Text('Status'),
                subtitle: Row(
                  children: [
                    Radio<int>(
                      value: 0,
                      groupValue: int.parse(status.toString()),
                      onChanged: (value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    const Text('Private'),
                    Radio<int>(
                      value: 1,
                      groupValue: int.parse(status.toString()),
                      onChanged: (value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    const Text('Public'),
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () async {
                    await _uploadBookFile(context);
                  },
                  child: const Text('Upload Book',
                      style: TextStyle(color: Colors.green)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
