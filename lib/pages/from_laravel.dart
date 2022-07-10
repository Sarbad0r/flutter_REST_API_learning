import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/models/contacts.dart';
import 'package:rest_api/pages/updating_name.dart';

class FromLaravel extends StatefulWidget {
  FromLaravel({Key? key}) : super(key: key);

  @override
  State<FromLaravel> createState() => _FromLaravelState();
}

class _FromLaravelState extends State<FromLaravel> {
  int? id;
  Future<List<Contact>> getListOfContact() async {
    List<Contact> listOfContact = [];
    try {
      var response = await http
          .get(Uri.parse('http://10.0.2.2:8000/contacts/submit/allData'));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> getList = map['contacts'];
        for (int i = 0; i < getList.length; i++) {
          listOfContact.add(Contact.fromJson(getList[i]));
          print(listOfContact[i]);
        }
        print("Length :${listOfContact.length}");
      }
    } catch (e) {
      print(e);
    }
    return listOfContact;
  }

  Future<void> postData(Contact contact) async {
    var respones = await http.post(
      Uri.parse('http://10.0.2.2:8000/contacts/submit'),
      body: jsonEncode(contact.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
  }

  Future<void> deleteData(int id) async {
    var res = await http.delete(
      Uri.parse("http://10.0.2.2:8000/contacts/submit/delete/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListOfContact();
  }

  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _messageController =
      TextEditingController(text: '');
  final TextEditingController _subjectController =
      TextEditingController(text: '');
  TextEditingController idController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(hintText: "id"),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(hintText: "email"),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(hintText: "message"),
            ),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(hintText: "subject"),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                onPressed: () async {
                  await postData(Contact(
                    name: _nameController.text,
                    email: _emailController.text,
                    subject: _subjectController.text,
                    message: _messageController.text,
                  )).then((value) {
                    _nameController.text = '';
                    _emailController.text = '';
                    _subjectController.text = '';
                    _messageController.text = '';
                    setState(() {});
                  });

                  FocusManager.instance.primaryFocus!.unfocus();
                },
                child: Text("Submit")),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Contact>>(
                future: getListOfContact(),
                builder: (context, snap) {
                  bool checkConnection =
                      snap.connectionState == ConnectionState.done;

                  if (!checkConnection) {
                    return Center(
                      child: Container(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator()),
                    );
                  }

                  if (snap.hasError) {
                    return Text("${snap.error}");
                  }

                  if (snap.data!.isEmpty) {
                    return Center(child: Container(child: Text("Пока пусто")));
                  }

                  return Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: snap.data!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            String refresh = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdaingName(
                                          contact: snap.data![index],
                                        )));
                            if (refresh == 'refresh') {
                              setState(() {});
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("${index + 1}: "),
                                      Text("${snap.data![index].name}"),
                                    ],
                                  ),
                                  Text("${snap.data![index].message}"),
                                  Text("${snap.data![index].email}"),
                                  Text("${snap.data![index].subject}")
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    deleteData(snap.data![index].id!)
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
