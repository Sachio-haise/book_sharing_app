import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:book_sharing_app/constants/env.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  Map<String, dynamic> validationErrors =
      {'name': '', 'password': '', 'email': ''}.obs;

  Future<void> authorize({
    required String name,
    required String email,
    required String password,
    required bool isSignIn,
  }) async {
    try {
      if(isLoading.value) return;
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
      debugPrint(responseBody);
      if (!isSignIn) validationErrors['name'] = '';
      validationErrors['email'] = '';
      validationErrors['password'] = '';
      if (response.statusCode == 200) {
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

  logout() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.toNamed('/auth');
  }
  clearErrors() {
    validationErrors['name'] = '';
    validationErrors['email'] = '';
    validationErrors['password'] = '';
  }
}
