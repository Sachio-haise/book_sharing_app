import 'package:book_sharing_app/widgets/input_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:book_sharing_app/controller/auth_controller.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthenticationController _authenticationController = Get.put(AuthenticationController());
  bool _isSignIn = false;

  void toggleField() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _authenticationController.validationErrors.clear();
      _isSignIn = !_isSignIn;
    });
  }

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
                Get.to(AuthPage());
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
      body:
      SingleChildScrollView(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Text(
                        _isSignIn ? "Sign In" : "Sign Up",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        if (!_isSignIn) // Only include the "Name" input if not signing in
                          Obx(() => InputFormWidget(
                            controller: _nameController,
                            hintText: "Name",
                            validateText: _authenticationController
                                .validationErrors['name'] ??
                                '',
                          )),
                        if (!_isSignIn) const SizedBox(
                          height: 10,
                        ),
                        Obx(() => InputFormWidget(
                          controller: _emailController,
                          hintText: "Email",
                          validateText: _authenticationController
                              .validationErrors['email'] ??
                              '',
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(() => InputFormWidget(
                          controller: _passwordController,
                          hintText: "Password",
                          obscureText: true,
                          validateText: _authenticationController
                              .validationErrors['password'] ??
                              '',
                        )),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {}
                            await _authenticationController.authorize(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                isSignIn: _isSignIn
                            );
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
                              _isSignIn ? "Login" : "Register",
                              style: const TextStyle(color: Colors.green),
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                _isSignIn ?
                                "Don't have an account?" :
                                "Already have an account?"
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            InkWell(
                              onTap: () {
                                if(_authenticationController.isLoading.value) return;
                                toggleField();
                              },
                              child: Text(
                                _isSignIn ? "Sign Up" : "Sign In",
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 1.5,
                                  decorationColor: Colors.green,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_isSignIn) const Divider(
                          height: 30,
                          thickness: 1,
                          color: Colors.green,
                        ),
                        if (_isSignIn) InkWell(
                          onTap: (){
                            Get.toNamed("/forget-password");
                          },
                          child: const Text(
                            "Forget Password",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.green
                            ),
                          ),
                        ),
                        const SizedBox(
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
