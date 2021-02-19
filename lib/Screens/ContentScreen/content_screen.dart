import 'package:cashcashproject/Screens/ContentScreen/add_notes_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/constrained_box_top.dart';
import 'components/profilPage.dart';

class ContentScreen extends StatelessWidget{

  getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionUid = prefs.getString('stringValue');

    return sessionUid;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cash Cash Content',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.tealAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ContentScreenStates(),
    );
  }
}

class ContentScreenStates extends StatefulWidget{

  @override
  State createState() => ContentScreenState();
}

class ContentScreenState extends State<ContentScreenStates>{

  String sessionUid = "";
  String appBarTitle = "Hutang / piutang";
  int _selectedIndex = 0;
  bool isHutangPiutang =  true;
  bool isProfil = false;
  final databaseReference = Firestore.instance;

  List<String> items;

  static const List<String> _widgetOptions = <String>[
    "Hutang / Piutang",
    "Pengeluaran / Pemasukan",
    "Profil Saya",
  ];


  @override
  void initState() {
    getSession();
  }

  static List<Widget> _rowOptions = <Widget>[
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBoxTop(
          money: 0,
          moneyFrom: "Hutang Saya",
          textColor: Colors.red.value,
        ),
        ConstrainedBoxTop(
          money: 0,
          moneyFrom: "Hutang Pelanggan",
          textColor: Colors.green.value,
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBoxTop(
          money: 0,
          moneyFrom: "Pengeluaran Saya",
          textColor: Colors.red.value,
        ),
        ConstrainedBoxTop(
          money: 0,
          moneyFrom: 'Pemasukan Saya',
          textColor: Colors.green.value,
        ),
      ],
    ),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      appBarTitle = _widgetOptions.elementAt(_selectedIndex).toString();
      isHutangPiutang ? isHutangPiutang = false : isHutangPiutang = true;
      if(_selectedIndex == 2){
        isProfil = true;
        getSession();
      }else{
        isProfil = false;
      }
    });
  }

  void getSession() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
       sessionUid = prefs.getString('stringValue');
    });
  }

  void getData() {
    databaseReference
        .collection('catatan')
        .document(sessionUid)
        .collection(isHutangPiutang ? "Hutang" : "Pengeluaran")
        .getDocuments()
        .then((QuerySnapshot snapshot) =>
      snapshot.documents.forEach((f) {
        items.add(
            f.data.toString()
        );
      }));

    databaseReference
        .collection('catatan')
        .document(sessionUid)
        .collection(isHutangPiutang ? "Piutang" : "Pemasukan")
        .getDocuments()
        .then((QuerySnapshot snapshot) =>
        snapshot.documents.forEach((f) {
          print(f.data);
        }));

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(title: new Text(appBarTitle),),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              isProfil ? profilPage(sessionUid: sessionUid) : _rowOptions.elementAt(_selectedIndex),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) {
                return AddNotesScreen(
                  appBarTitle: _widgetOptions.elementAt(_selectedIndex),
                  isHutangPiutang: isHutangPiutang,
                );
              },
            ),
          );
        },
        child:
        Icon(isProfil ? Icons.remove_circle_outline : Icons.add , color: Colors.black,),
        backgroundColor: Colors.lightGreenAccent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text("Hutang"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text("Transaksi"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profil"),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}



