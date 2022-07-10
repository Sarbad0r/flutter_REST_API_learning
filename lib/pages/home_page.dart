import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rest_api/models/todo.dart';
import 'package:rest_api/pages/from_laravel.dart';
import 'package:rest_api/pages/star_wars_api_from_github.dart';
import 'package:rest_api/repository/todo_repository.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, duration, c) => HomePage(),
                transitionDuration: const Duration(seconds: 0)));
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Todo newTodo = Todo(
                userId: 3,
                completed: false,
                title: "added to todo",
              );

              TodoRepository().postTodo(newTodo).then((value) => print(value));
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text("REST API"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FromLaravel()));
                },
                child: Text("Laravel")),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DeleteAfter()));
                },
                child: Text(
                  "Go",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: FutureBuilder<List<Todo>>(
            future: TodoRepository().getTodoList(),
            builder: (context, snap) {
              bool loadingConnection =
                  snap.connectionState == ConnectionState.done;
              if (!loadingConnection) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snap.hasError) {
                return Text("${snap.error.toString()}");
              } else {
                return ListView.builder(
                    itemCount: snap.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text("${snap.data?[index].id}")),
                            Expanded(
                                flex: 1,
                                child: Text("${snap.data?[index].title}")),
                            Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        TodoRepository()
                                            .patchCompleted(snap.data![index])
                                            .then((value) {
                                          return ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text("${value}")));
                                        });
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFFA726),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(child: Text("patch")),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        TodoRepository()
                                            .putCompleted(snap.data![index]);
                                        //this is update
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(child: Text("put")),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        TodoRepository()
                                            .deleteCompleted(snap.data![index]);
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.pink,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(child: Text("delete")),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
