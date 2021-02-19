import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final TextInputType type;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;

  const TextFieldContainer({
    Key key,
    this.type,
    this.hintText,
    this.icon,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child:
      TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(icon),
        ),
      ),
    );
  }
}