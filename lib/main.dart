import 'package:flutter/material.dart';
import 'package:rest_api/pages/home_page.dart';
import 'package:rest_api/repository/todo_repository.dart';

void main() {
  
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.amber),
    home: HomePage(),
  ));
}
