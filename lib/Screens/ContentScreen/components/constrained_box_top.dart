import 'package:flutter/material.dart';

class ConstrainedBoxTop extends StatelessWidget {
  final int money;
  final String moneyFrom;
  final int textColor;

  const ConstrainedBoxTop({
    Key key,
    this.money,
    this.moneyFrom,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 150,
          minWidth: 200,
        ),
        child:  Card(
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: Colors.lime[50],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Rp "+money.toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: new Color(textColor),
                ),
              ),
              SizedBox(height: 10,),
              Text(
                moneyFrom,
                style: TextStyle(
                  fontSize: 12,
                  color: new Color(textColor),
                ),
              ),
            ],
          ),
        ),
      );
  }
}