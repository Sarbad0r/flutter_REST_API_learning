import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rest_api/models/todo.dart';
import 'package:rest_api/repository/repository.dart';
import 'package:http/http.dart' as http;

class TodoRepository implements Repository {
  TodoRepository() {
    fetchRepo();
  }
  String url = 'https://jsonplaceholder.typicode.com';

  @override
  Future<String> deleteCompleted(Todo todo) async {
    String res = 'false';
    await http.delete(Uri.parse("$url/todos/${todo.id}")).then((value) {
      print(value.body);
      return res = 'true';
    });
    return res;
  }

  @override
  Future<List<Todo>> getTodoList() async {
    List<Todo> list = [];
    try {
      var respones = await http.get(Uri.parse('$url/todos'));
      if (respones.statusCode == 200) {
        print("${respones.body}");
        List<dynamic> map = jsonDecode(respones.body);
        for (int i = 0; i < map.length; i++) {
          list.add(Todo.fromJson(map[i]));
        }
      }
    } catch (e) {
      print("error$e");
    }
    return list;
  }

  @override
  Future<String> patchCompleted(Todo todo) async {
    String resData = '';
    await http.patch(Uri.parse("$url/todos/${todo.id}"), body: {
      'completed': (todo.completed == true
              ? ScaffoldMessenger(
                  child: SnackBar(content: (Text("Already true"))))
              : true)
          .toString()
    }, headers: {
      'Authorization': 'your_token'
    }).then((value) {
      Map<String, dynamic> result = json.decode(value.body);

      print(result);

      return resData = result['completed'];
    });

    return resData;
  }

  @override
  Future<String> putCompleted(Todo todo) async {
    String resData = '';
    await http.put(
      Uri.parse("$url/todos/${todo.id}"),
      body: {
        'completed': (todo.completed == true
                ? ScaffoldMessenger(
                    child: SnackBar(content: (Text("Already true"))))
                : true)
            .toString()
      },
    ).then((value) {
      Map<String, dynamic> result = json.decode(value.body);

      print(result);

      return resData = result['completed'];
    });

    return resData;
  }

  @override
  Future<String> postTodo(Todo todo) async {
    var respones = await http.post(Uri.parse("$url/todos/"),
        body: todo.toJson());

    print(respones.body);
    return 'true';
  }

  void fetchRepo() async {
    await getTodoList();
  }
}
