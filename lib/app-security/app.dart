import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("hy there123"), centerTitle: true),
      body: Column(children: [Container(alignment: Alignment.bottomCenter)]),
    );
  }
}
