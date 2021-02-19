import 'package:cashcashproject/Screens/SignScreen/components/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController emailInputController;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.emailInputController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: emailInputController,
        validator: (String value) {
          if (value.isEmpty) {
            return "retry";
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.green,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.green[800],
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}