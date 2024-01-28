import 'package:book_sharing_app/model/user.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:book_sharing_app/constants/env.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final isUpdating = false.obs;
  Map<String, dynamic> validationErrors =
      {'name': '', 'password': '', 'email': '', 'old_password': ''}.obs;

  Future<User> getUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      print("getUser - Token: $token");

      final uri = Uri.parse("$baseUrl/user");
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print("getUser - Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Successfully fetched user data
        final dynamic data = json.decode(response.body);
        final dynamic userData = data['data'];
        print("getUser - User Data: $userData");

        final User user = User.fromJson(userData);
        return user;
        // You can now handle the user data as needed
        // For example, storing it in a Hive box
        // final userBox = await Hive.openBox('user');
        //userBox.put('user', User(id: userData['id'], name: userData['name'], email: userData['email']))
      } else {
        // Handle error status codes
        print("getUser - Error: ${response.reasonPhrase}");
        return User(
            id: null,
            name: '',
            email: '',
            profile: Profile(id: null, public_path: ''),
            description: '',
            created_at: '');
      }
      // userBox.put('user', User(id: user.id, name: user.name, email: user.email))
    } catch (e) {
      print("getUser - Error: $e");
      if (kDebugMode) {
        print(e);
      }
      return User(
          id: null,
          name: '',
          email: '',
          profile: Profile(id: null, public_path: ''),
          description: '',
          created_at: '');
    }
  }

  Future<void> authorize({
    required String name,
    required String email,
    required String password,
    required bool isSignIn,
  }) async {
    try {
      if (isLoading.value) return;
      debugPrint("submit");
      isLoading.value = true;
      var data = {
        'name': name,
        'email': email,
        'password': password,
      };
      var response = await http.post(
        isSignIn ? Uri.parse('$baseUrl/login') : Uri.parse('$baseUrl/register'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      var responseBody = response.body;
      if (!isSignIn) validationErrors['name'] = '';
      validationErrors['email'] = '';
      validationErrors['password'] = '';
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedData = json.decode(responseBody);
        if (decodedData.containsKey('token')) {
          debugPrint(decodedData['token']);
          SharedPreferences.setMockInitialValues({});
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          // Save an String value to 'action' key.
          await prefs.setString('token', decodedData['token']);
          Get.toNamed('/');
        }
        isLoading.value = false;
      } else {
        isLoading.value = false;
        var errorResponse = json.decode(responseBody);
        if (errorResponse.containsKey('errors')) {
          var errors = errorResponse['errors'];
          // debugPrint(errors);
          errors.forEach((field, errorMessage) {
            validationErrors[field] = errorMessage[0];
            debugPrint(errorMessage[0]);
          });
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future changePassword({
    required int? id,
    required String oldPassword,
    required String password,
  }) async {
    if (isUpdating.value) return;
    debugPrint("submit");
    try{
      isUpdating.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      debugPrint("token is $token");

      var data = {
        'id': "$id" ,
        'old_password': oldPassword,
        'password': password
      };

      var response = await http.post(
        Uri.parse('$baseUrl/change-password'),
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
        body: data,
      );

      var responseBody = response.body;
      validationErrors['old_password'] = '';
      validationErrors['password'] = '';
      print(response.statusCode);
      if (response.statusCode == 200) {
        var decodedData = json.decode(responseBody);
        if (decodedData.containsKey('token')) {
          debugPrint(decodedData['token']);
          SharedPreferences.setMockInitialValues({});
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          // Save an String value to 'action' key.
          await prefs.setString('token', decodedData['token']);
        }
        isUpdating.value = false;
      } else {
        isUpdating.value = false;
        var errorResponse = json.decode(responseBody);
        if (errorResponse.containsKey('errors')) {
          var errors = errorResponse['errors'];
          // debugPrint(errors);
          errors.forEach((field, errorMessage) {
            validationErrors[field] = errorMessage[0];
            debugPrint(errorMessage[0]);
          });
        }
      }
      return response.statusCode;
    }catch(e){
      print(e);
      isUpdating.value = false;
      return 500;
    }
  }

  Future updateProfile({
    required int? id,
    required String name,
    required String email,
    String? description,
  }) async {
    if (isLoading.value) return;
    debugPrint("submit");
   try{
     isLoading.value = true;

     final SharedPreferences prefs = await SharedPreferences.getInstance();
     final String? token = prefs.getString('token');
     debugPrint("token is $token");

     var data = {
       'id': "$id" ,
       'name': name,
       'email': email,
       'description': description,
     };

     var response = await http.post(
       Uri.parse('$baseUrl/update-profile'),
       headers: {
         'Accept': 'application/json',
         'Authorization': "Bearer $token",
       },
       body: data,
     );

     var responseBody = response.body;
     validationErrors['name'] = '';
     validationErrors['email'] = '';
     print(response.statusCode);
     if (response.statusCode == 200) {
       var decodedData = json.decode(responseBody);
       if (decodedData.containsKey('token')) {
         debugPrint(decodedData['token']);
         SharedPreferences.setMockInitialValues({});
         final SharedPreferences prefs = await SharedPreferences.getInstance();
         // Save an String value to 'action' key.
         await prefs.setString('token', decodedData['token']);
       }
       isLoading.value = false;
     } else {
       isLoading.value = false;
       var errorResponse = json.decode(responseBody);
       if (errorResponse.containsKey('errors')) {
         var errors = errorResponse['errors'];
         // debugPrint(errors);
         errors.forEach((field, errorMessage) {
           validationErrors[field] = errorMessage[0];
           debugPrint(errorMessage[0]);
         });
       }
     }
     return response.statusCode;
   }catch(e){
     print(e);
     isLoading.value = false;
     return 500;
   }
  }

  Future uploadProfile({
    required String? id,
    required File image
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    debugPrint("token is $token");
    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();

    var uri = Uri.parse("$baseUrl/upload-profile");

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('profile', stream, length,
        filename: basename(image.path));

    request.fields['id'] = id ?? '';
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(multipartFile);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Failed to upload file. Status code: ${response.statusCode}');
      }
      return response.statusCode;
    } catch (error) {
      print('Error during file upload: $error');
      return 500;
    }
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.toNamed('/');
  }

  clearErrors() {
    validationErrors['name'] = '';
    validationErrors['email'] = '';
    validationErrors['password'] = '';
  }
}
