import 'package:flutter/material.dart';

class loggedScreen extends StatelessWidget {
  final String name;
  const loggedScreen({super.key, required this.name});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş Yapıldı")),
      body: Center(child: Text('Hoşgeldiniz $name')),
    );
  }
}
