import 'package:flutter/material.dart';

class InputFormWidget extends StatefulWidget {
  const InputFormWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validateText
  });

  final String hintText;
  final String validateText;
  final TextEditingController controller;

  @override
  State<InputFormWidget> createState() => _InputFormWidgetState();
}

class _InputFormWidgetState extends State<InputFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          autofocus: true,
          controller: widget.controller,
          decoration:    InputDecoration(
            labelText: widget.hintText,
            focusColor: Colors.green,
            floatingLabelStyle: const TextStyle(
                color: Colors.green
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green), // Set the underline color
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red), // Set the underline color when there is an error
            ),
          ),
        ),
        Text(
          widget.validateText,
          style: const TextStyle(
            color: Colors.red,
            fontSize:  12.0
          ),
        ),
      ],
    );
  }
}

    
    