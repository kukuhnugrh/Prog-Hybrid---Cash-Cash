import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/text_field_container.dart';

class AddNotesScreen extends StatefulWidget{
  final String appBarTitle;
  final bool isHutangPiutang;

  const AddNotesScreen({
    Key key,
    this.appBarTitle,
    this.isHutangPiutang,
  }): super(key: key);

  @override
  State createState() => NotePageState();
}

enum WidgetMarker { hutangPiutang, pengeluaranPemasukan }

class NotePageState extends State<AddNotesScreen>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nominalController;
  TextEditingController asalController;
  TextEditingController dateController;
  TextEditingController catatanController;

  @override
  void initState() {
    // TODO: implement initState
    nominalController = new TextEditingController();
    asalController = new TextEditingController();
    dateController = new TextEditingController();
    catatanController = new TextEditingController();
    super.initState();
  }

  WidgetMarker selectedWidgetMarker = WidgetMarker.hutangPiutang;
  bool activeTab = true;
  DateTime selectedDate = DateTime.now();
  TextEditingController _textEditingController = TextEditingController();
  final databaseReference = Firestore.instance;

  static List<Widget> _radioTitle = <Widget>[
    Text(
      "Hutang",
      style: TextStyle(
        color: Colors.red,
      ),
    ),
    Text(
      "Piutang",
      style: TextStyle(
        color: Colors.green,
      ),
    ),
    Text(
      "Pengeluaran",
      style: TextStyle(
        color: Colors.red,
      ),
    ),
    Text("Pemasukan",
      style: TextStyle(
        color: Colors.green,
      ),
    ),
  ];

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context, 
      initialDate: selectedDate, 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
        dateController.text =  DateFormat('yyy-MM-dd').format(selectedDate);
      });
    }
  }

  void reverseTab(){
    setState(() {
      activeTab ? activeTab = false : activeTab = true;
    });
  }

  void createRecord(String asal, String nominal, String date, String catatan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionUid = prefs.getString('stringValue');

    await databaseReference.collection("catatan")
        .document(sessionUid)
        .collection(activeTab ? widget.isHutangPiutang ? "Hutang" : "Pengeluaran" : widget.isHutangPiutang ? "Piutang" : "Pemasukan")
        .document(DateTime.now().toString())
        .setData({
      'sessionUid': sessionUid,
      'asalMuasal': widget.isHutangPiutang ? "Hutang/Piutang" : "Pengeluaran/Pemasukan",
      'status': activeTab ? widget.isHutangPiutang ? "Hutang" : "Pengeluaran" : widget.isHutangPiutang ? "Piutang" : "Pemasukan",
      'asal/Nama': asal,
      'nominal': nominal,
      'tanggal': date,
      'catatan': catatan,
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Status'),
          content: const Text('Data Berhasil Ditambahkan'),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: Text(widget.appBarTitle),),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Expanded(
                        flex: 2,
                        child:new SizedBox(
                          width: 20,
                          child: FlatButton(
                            onPressed: () {
                              if(!activeTab){
                                reverseTab();
                              }
                            },
                            child: widget.isHutangPiutang ? _radioTitle.elementAt(0) : _radioTitle.elementAt(2),
                            color: activeTab? Colors.lightGreenAccent : Colors.grey[300],
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 2,
                        child:new SizedBox(
                          width: 20,
                          child: FlatButton(
                            onPressed: () {
                              if(activeTab){
                                reverseTab();
                              }
                            },
                            child: widget.isHutangPiutang ? _radioTitle.elementAt(1) : _radioTitle.elementAt(3),
                            color: activeTab?  Colors.grey[300] : Colors.lightGreenAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFieldContainer(
                    type: TextInputType.number,
                    hintText: "Rp. ",
                    icon: Icons.monetization_on,
                    controller: nominalController,
                  ),
                  SizedBox(height: 20),
                  TextFieldContainer(
                    type: TextInputType.text,
                    hintText: "Nama / Asal",
                    icon: Icons.person,
                    controller: asalController,
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child:
                    TextFormField(
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: "Tanggal yyyy-MM-dd",
                        icon: Icon(Icons.date_range),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFieldContainer(
                    type: TextInputType.text,
                    hintText: "Catatan / Keterangan",
                    icon: Icons.note,
                    controller: catatanController,
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        color: Colors.red,
                        onPressed: () {
                          createRecord(
                            asalController.text,
                            nominalController.text,
                            dateController.text,
                            catatanController.text,
                          );
                        },
                        child: Text(
                          "Tambah Data",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}



