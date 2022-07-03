import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/models/user.dart';

class DeleteAfter extends StatefulWidget {
  DeleteAfter({Key? key}) : super(key: key);

  @override
  State<DeleteAfter> createState() => _DeleteAfterState();
}

class _DeleteAfterState extends State<DeleteAfter> {
  Future<List<User>> getUsers() async {
    List<User> getUser = [];

    try {
      var respones = await http.get(Uri.parse(
          "https://raw.githubusercontent.com/Sarbad0r/mockjson_1/main/db.json"));

      if (respones.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(respones.body);
        List<dynamic> list = map['users'];
        for (int i = 0; i < list.length; i++) {
          getUser.add(User.fromJson(list[i]));
        }
      }
    } catch (e) {
      print("Error:$e");
    }
    return getUser;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder<List<User>>(
            future: getUsers(),
            builder: ((context, snapshot) {
              bool checkConnection =
                  snapshot.connectionState == ConnectionState.done;

              if (!checkConnection) {
                return const Center(child:  CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "${snapshot.data![index].img}")),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                              ),
                              Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Text(
                                    "${snapshot.data?[index].title!.toUpperCase()}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ))
                            ],
                          ),
                        ),
                      );
                    });
              }
            })),
      ),
    );
  }
}
