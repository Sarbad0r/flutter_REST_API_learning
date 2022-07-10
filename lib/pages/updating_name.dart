import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rest_api/models/contacts.dart';
import 'package:http/http.dart' as http;

class UpdaingName extends StatefulWidget {
  Contact? contact;
  UpdaingName({Key? key, this.contact}) : super(key: key);

  @override
  State<UpdaingName> createState() => _UpdaingNameState();
}

class _UpdaingNameState extends State<UpdaingName> {
  TextEditingController _nameContoller = TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.contact != null) {
      _nameContoller.text = widget.contact!.name!;
    }
  }

  Future<void> update(int id) async {
    await http.put(
      Uri.parse("http://10.0.2.2:8000/contacts/update/$id"),
      body: json.encode({'name': _nameContoller.text}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                update(widget.contact!.id!).then((value) {
                  Navigator.pop(context, 'refresh');
                });
              },
              child: Text(
                "Сохранить",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          TextField(
            controller: _nameContoller,
          )
        ],
      ),
    );
  }
}
