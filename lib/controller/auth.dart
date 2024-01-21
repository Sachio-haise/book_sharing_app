import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Authentication extends GetxController{
  final isLoading = false.obs;

  Future register(
  {
    required String name,
    required String email,
    required String password
  }) async{
   try{
     isLoading.value = true;
     var data = {
       'name': name,
       'email': email,
       'password' : password
     };

     var response = await http.post(
         Uri.parse('localhost' + 'register'),
         headers: {
           'Accept': 'application/json',
         },
         body: data
     );

     if(response.statusCode == 200){
       debugPrint(json.decode(response.body));
       isLoading.value = false;
     }else{
       debugPrint(json.decode(response.body));
       isLoading.value = false;
     }
   }catch(e){
     print(e.toString());
   }
  }
}