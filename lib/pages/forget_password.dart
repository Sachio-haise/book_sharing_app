import 'package:book_sharing_app/controller/auth_controller.dart';
import 'package:book_sharing_app/widgets/input_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _resetCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final AuthenticationController _authenticationController = Get.find();
  String resetCode = '';
  String status = '1';


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
                  style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: InkWell(
              onTap: () {
                Get.toNamed('/');
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage:
                NetworkImage("https://img6.arthub.ai/6497fccf-d831.webp"),
              ),
            ),
          )
        ],
        toolbarHeight: kToolbarHeight + 20,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:120,left: 15.0, right: 15.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.greenAccent,
                  offset: Offset(
                    2.0,
                    10.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                ), //BoxShadow
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
                //BoxShadow
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Text(
                         "Forget Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                   padding: const EdgeInsets.only(left: 20.0),
                   child: Row(
                     children: [
                       if(status != '4')  const Text(
                         "*",
                       style: TextStyle(
                         color: Colors.green,
                         fontWeight: FontWeight.bold,
                         fontSize: 18.0
                       ),
                       ),

                       const SizedBox(width: 5.0,),
                       if(status != '4')    Text(
                           status == '1' ?  "Enter your email to reset the code." :
                           status == '2' ? "Enter 6-digit code sent to your phone."
                               :  "Reset Password." ,
                           style: const TextStyle(
                             fontSize: 16.0,
                             color: Colors.grey
                           ),
                       ),
                     ],
                   ),
                 ),
                  if(status == '2')  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0,top: 5.0),
                      child: Text(
                        "We've sent the reset code to ${_emailController.text.trim()}. Please check your Email.",
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        if(status == '1') Obx(() => InputFormWidget(
                          controller: _emailController,
                          hintText: "Email",
                          validateText: _authenticationController
                              .validationErrors['email'] ??
                              '',
                        )),

                        if(status == '2') Obx(() => InputFormWidget(
                          controller: _resetCodeController,
                          hintText: "Reset Code",
                          validateText: _authenticationController
                              .validationErrors['reset_code'] ??
                              '',
                        )),
                        if(status == '3') Obx(() => InputFormWidget(
                          obscureText: true,
                          controller: _passwordController,
                          hintText: "New Password",
                          validateText: _authenticationController
                              .validationErrors['password'] ??
                              '',
                        )),

                        if(status == '3') Obx(() => InputFormWidget(
                          obscureText: true,
                          controller: _passwordConfirmController,
                          hintText: "Confirm Password",
                          validateText: _authenticationController
                              .validationErrors['password_confirmation'] ??
                              '',
                        )),

                         if(status == '4') Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                    maxRadius: 30,
                                    backgroundColor: const Color(0xff94d500),
                                    child: IconButton(
                                        onPressed: (){},
                                        icon: const Icon(Icons.check),
                                      iconSize: 30,
                                      color: Colors.white,
                                    )
                                ),
                              ),
                              const SizedBox(height: 5.0,),
                              const Center(
                                  child: Text(
                                      'Your Password has been reset',
                                      style: TextStyle(
                                        color:Colors.grey
                                      ),
                                  ),
                              ),
                              const Center(
                                child: Text(
                                  'successfully!',
                                  style: TextStyle(
                                      color:Colors.grey
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:15.0,bottom: 15.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed("/auth");
                                    },
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.green
                                      ),
                                    ),
                                ),
                              )
                            ],
                          )
                        ,



                        if(status != '4') const SizedBox(
                          height: 10,
                        ),
                        if(status != '4')  ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {}
                            if(status == '1'){
                              final response = await _authenticationController.forgetPassword(
                                  email: _emailController.text.trim()
                              );
                              if(response['status'] == '200') {
                                setState(() {
                                  resetCode = response['code'];
                                  status = '2';
                                });
                              }
                               print(resetCode);
                            }else if(status == '2'){
                              final response = _authenticationController.checkCode(
                                  resetCode: resetCode,
                                  confirmCode: _resetCodeController.text.trim()
                              );
                              if(response['status'] == '200') {
                                setState(() {
                                  status = '3';
                                });
                              }
                            }else if(status == '3'){
                              final response = await _authenticationController.resetPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  passwordConfirmation: _passwordConfirmController.text.trim()
                              );
                              if(response['status'] == '200') {
                                setState(() {
                                  status = '4';
                                });
                              }
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
                                : Text(
                              status == '1' ? "Request" : 'Confirm',
                              style: const TextStyle(color: Colors.green),
                            );
                          }),
                        ),
                        if(status != '4')   const SizedBox(
                          height: 10,
                        ),
                        if(status != '4')  const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
