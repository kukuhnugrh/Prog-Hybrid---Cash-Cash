import 'package:cashcashproject/Screens/SignScreen/components/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatelessWidget {
  final TextEditingController pwdInputController;

  const RoundedPasswordField({
    Key key,
    this.pwdInputController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: pwdInputController,
        validator: (String value) {
          if(value.isEmpty){
            return "retry";
          }else{
            return null;
          }
        },
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: Colors.green,
          ),
          hintText: "Masukkan Password Anda",
          hintStyle: TextStyle(
            color: Colors.green[800],
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}