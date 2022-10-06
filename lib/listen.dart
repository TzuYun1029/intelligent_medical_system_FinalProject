import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'socket_tts.dart';
import 'sound_player.dart';
import 'sound_recorder.dart';
import 'flutter_tts.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'socket_stt.dart';

class ListenPage extends StatefulWidget {
  const ListenPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ListenPage> createState() => ListenPageState();
}

class ListenPageState extends State<ListenPage>{
  @override
  Widget build(BuildContext context) => Scaffold(
    // 設定不讓鍵盤技壓頁面
    resizeToAvoidBottomInset: false,
    appBar: AppBar(
        title: const Text('語音輸入 APP'), backgroundColor: Colors.white),
    // set background color
    backgroundColor: Colors.white,
    body: Column(
      children: [
        Flexible(
          flex: 1,
          child: speakbutton(),
        ),
        Flexible(
          flex: 3,
          child: Text(
              "按下台語鍵可以把台語轉成文字，按下國語鍵可以把國語轉成文字，返回鍵可以刪除文字，長按可以整個刪除，確認鍵可以複製所有文字",
              style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
  Widget speakbutton() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(Icons.hearing_outlined),
        color: Colors.black45,
        iconSize: 80.0,
        splashRadius: 45.0,
        onPressed: () async {
          // 得到 TextField 中輸入的 value
          String strings =
              "按下台語鍵可以把台語轉成文字，按下國語鍵可以把國語轉成文字，返回鍵可以刪除文字，長按可以整個刪除，確認鍵可以複製所有文字";
          // 如果為空則 return
          if (strings.isEmpty) return;
          // connect to text2speech socket
          // The default is man voice.
          // If you want a female's voice, put "female" into the parameter.
          // parameter: call back function, speech synthesized text, (female)
          await Text2SpeechFlutter().speak(strings);
          setState(() {});
        },
      ),
    );
  }
}