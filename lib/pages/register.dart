import 'package:book_sharing_app/widgets/input_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        // leading: const Padding(
        //   padding: EdgeInsets.only(top:6.0,left: 8.0,right: 8.0),
        //   child: Image(
        //     image: AssetImage('assets/images/logo_.png'),
        //   ),
        // ),
        title:
        const Center(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/logo_.png'),
                  width: 30.0,
                  height: 30.0,
                ),
                Text('Book Library',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                  ),),
              ],
            )
            ),
        actions:  [
          Padding(
            padding:const EdgeInsets.only(right: 16.0,top: 8.0),
            child: InkWell(
              onTap: () {
                Get.to(RegisterPage());
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    "https://img6.arthub.ai/6497fccf-d831.webp"
                ),
              ),
            ),
          )
        ],
        toolbarHeight: kToolbarHeight + 20,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top:120.0,left: 15.0,right: 15.0
        ),
        child: Container(
          height: 400.0,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.green,
                width: 1.0
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow:const [
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
              children: [
                const Padding(
                  padding: EdgeInsets.only(top:20.0),
                  child: Center(
                    child:
                      Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color:Colors.green
                        ),
                      ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:25.0,right: 25.0),
                  child: Column(
                    children: [
                      InputFormWidget(
                          controller: _nameController,
                          hintText: "Name",
                          errorText: "Fill the name!",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputFormWidget(
                        controller: _emailController,
                        hintText: "Email",
                        errorText: "Fill the email!",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputFormWidget(
                        controller: _passwordController,
                        hintText: "Password",
                        errorText: "Fill the password!",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {

                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:  Colors.green,
                          ),
                          child: const Text("Register")
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          SizedBox(width: 10.0,),
                          InkWell(
                            child: Text(
                                "Sign In",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
                                decorationColor: Colors.green,
                                color: Colors.green,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
