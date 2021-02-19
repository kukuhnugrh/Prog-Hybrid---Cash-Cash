import 'package:flutter/material.dart';

class profilPage extends StatelessWidget{
  final String sessionUid;

  const profilPage({
    Key key,
    this.sessionUid
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 150,
            minWidth: 400,
          ),
          child:  Card(
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Colors.lime[50],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person_pin,
                    size: 70.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "HALO BOS",
                      ),
                      Text(
                        sessionUid,
                      ),
                    ],
                  )
                ],
              )
          ),
        ),
      ],
    );
  }
}