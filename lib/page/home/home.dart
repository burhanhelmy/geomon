import 'package:flutter/material.dart';
import 'package:geomon/page/home/widget/bottom_drawer.dart';
import 'package:geomon/page/home/widget/map.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        // children: <Widget>[],
        children: <Widget>[MapWidget(), BottomDrawer()],
      ),
    );
  }
}
