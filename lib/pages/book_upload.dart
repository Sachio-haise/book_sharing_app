import 'dart:io';
import 'package:book_sharing_app/model/book.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BookCreatePage extends StatefulWidget {
  const BookCreatePage({Key? key}) : super(key: key);

  @override
  State<BookCreatePage> createState() => _BookCreatePageState();
}

class _BookCreatePageState extends State<BookCreatePage> {
  // User user = Get.find<AuthenticationController>().getUser() as User;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  File? photo;
  File? book;
  int status = 0; // 0 for private, 1 for public
  String userName = 'Myo Min Ko';

  Future<void> _uploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        photo = File(pickedFile.path);
        print(photo);
      });
    }
  }

  Future<void> _uploadBook() async {
    final filePicker = FilePicker.platform;
    final pickedFile = await filePicker
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (pickedFile != null) {
      setState(() {
        book = File(pickedFile.files.single.path!);
        print(book);
      });
    }
  }

  Future<void> _uploadBookFile() async {
    //apicall
    try {
      Book.createBook(
          userId: '5',
          name: nameController.text,
          description: descriptionController.text,
          review: reviewController.text,
          photo: photo!,
          book: book!,
          status: status.toString());
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
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
        centerTitle: true,
        title: const Text('Book Upload'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: Text(userName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
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
                    margin: const EdgeInsets.all(8.0),
                    height: 150,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey, // Set border color to grey
                        style: BorderStyle.solid, // Set border style to dashed
                      ),
                    ),
                    child: photo != null
                        ? Image.file(
                            photo!,
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
                  if (book != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Selected Book'),
                          content: Image.file(book!),
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
                  margin: const EdgeInsets.all(8.0),
                  height: 100,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey, // Set border color to grey
                      style: BorderStyle.solid, // Set border style to dashed
                    ),
                  ),
                  child: book != null
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.menu_book_outlined),
                            Text(book!.path.split('/').last),
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
                      groupValue: status,
                      onChanged: (value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    const Text('Private'),
                    Radio<int>(
                      value: 1,
                      groupValue: status,
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
              ElevatedButton(
                onPressed: () async {
                  await _uploadBookFile();
                },
                child: const Text('Upload Book',
                    style: TextStyle(fontSize: 20, color: Colors.green)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
