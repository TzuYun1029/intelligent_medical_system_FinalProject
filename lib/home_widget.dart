import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'speak.dart';
import 'listen.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}
class _HomeState extends State<Home> {
  int currentIndex = 0;
  final children = [
    MainPage(title: '語音輸入'),
    ListenPage(title: '解說'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('語音輸入 App'),
      ),
      body: children[currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        selectedFontSize: 16,
        onTap: onTabTapped, // new
        backgroundColor: Colors.brown,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.white70,
        currentIndex: currentIndex, // new
        // currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.radio_button_checked_outlined),
            title: new Text('語音'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.hearing_rounded),
            title: new Text('解說'),
          ),
        ],
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}