import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'socket_tts.dart';
import 'sound_player.dart';
import 'sound_recorder.dart';
import 'flutter_tts.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'socket_stt.dart';

String initInput = '';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  // get SoundRecorder
  final recorder1 = SoundRecorder();
  final recorder2 = SoundRecorder();

  // get soundPlayer
  final player = SoundPlayer();

  // Declare TextEditingController to get the value in TextField
  TextEditingController taiwanessController = TextEditingController();
  TextEditingController chineseController = TextEditingController();
  TextEditingController recognitionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    recorder1.init();
    recorder2.init();
    player.init();
  }

  @override
  void dispose() {
    recorder1.dispose();
    recorder2.dispose();
    player.dispose();
    super.dispose();
  }

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
        // Flexible(
        //   flex: 1,
        //   child: speakbutton(),
        // ),
        Flexible(
          flex: 8,
          child: Center(child: buildOutputField()),
        ),
        Flexible(
          flex: 5,
          child: Container(
            // margin: const EdgeInsets.symmetric(vertical: 0.0),
            height: 250.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  width: 400.0,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Flexible(
                        // flex: 3,
                        child: Row(
                          children: [
                            Flexible(
                              child: Center(child: Taiwanesebutton()),
                            ),
                            Flexible(
                              child: Center(child: Chinesebutton()),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        // flex: 3,
                        child: Row(
                          children: [
                            Flexible(
                              child: Center(child: confirmbutton()),
                            ),
                            Flexible(
                              child: Center(child: backspacebutton()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 400.0,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              child: Center(child: commabutton()),
                            ),
                            Flexible(
                              child: Center(child: periodbutton()),
                            ),
                            Flexible(
                              child: Center(child: comma1button()),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              child: Center(child: questionbutton()),
                            ),
                            Flexible(
                              child: Center(child: exclamationbutton()),
                            ),
                            Flexible(
                              child: Center(child: tildebutton()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
  Future<String?> TtoC(String taiInput) async {
    Map body = {
      'text': taiInput,
    };

    String jsonString = json.encode(body);
    String response = await fetchData(
        'http://192.168.210.20:5000/', jsonString); // state 2
    print(response); //debug
    return response;
  }
  Future<String> fetchData(String url, String jsonString) async {
    try {
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonString);
      return response.body;
    } catch (error) {
      return '{"status":"fail", "result":\"${error.toString()}\"}';
    }
  }
  Widget Taiwanesebutton() {
    // whether is recording
    final isRecording1 = recorder1.isRecording;
    final isRecording2 = recorder2.isRecording;
    // if recording => icon is Icons.stop
    // else => icon is Icons.mic
    final icon = isRecording1 ? Icons.stop : Icons.mic;
    // if recording => color of button is red
    // else => color of button is white

    final primary = isRecording2
        ? Colors.grey[300]
        : (isRecording1 ? Colors.red[700] : Colors.red[400]);
    // if recording => text in button is STOP
    // else => text in button is START
    final text = isRecording1 ? 'STOP' : '台語';
    // if recording => text in button is white
    // else => color of button is black
    // final onPrimary = isRecording1 ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      // style: ElevatedButton.styleFrom(
      //   // 設定 Icon 大小及屬性
      //   minimumSize: const Size(175, 50),
      //   primary: primary,
      //   onPrimary: onPrimary,
      // ),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(43),
        primary: primary,
        onPrimary: Colors.white,
      ),
      icon: Icon(icon),
      label: Text(
        text,
        // 設定字體大小及字體粗細（bold粗體，normal正常體）
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      // 當 Iicon 被點擊時執行的動作
      onPressed: () async {
        // getTemporaryDirectory(): 取得暫存資料夾，這個資料夾隨時可能被系統或使用者操作清除
        Directory tempDir = await path_provider.getTemporaryDirectory();
        // define file directory
        String path = '${tempDir.path}/SpeechRecognition.wav';
        // 控制開始錄音或停止錄音
        await recorder1.toggleRecording(path);
        // When stop recording, pass wave file to socket
        if (!recorder1.isRecording) {
          await Speech2Text().connect(path, setTxt, "Minnan");
        }
        // set state is recording or stop
        setState(() {
          recorder1.isRecording;
        });
      },
    );
  }

  Widget Chinesebutton() {
    // whether is recording
    final isRecording1 = recorder1.isRecording;
    final isRecording2 = recorder2.isRecording;
    // if recording => icon is Icons.stop
    // else => icon is Icons.mic
    final icon = isRecording2 ? Icons.stop : Icons.mic;
    // if recording => color of button is red
    // else => color of button is white
    final primary = isRecording1
        ? Colors.grey[300]
        : (isRecording2 ? Colors.green[700] : Colors.green[400]);
    // if recording => text in button is STOP
    // else => text in button is START
    final text = isRecording2 ? 'STOP' : '國語';
    // if recording => text in button is white
    // else => color of button is black
    // final onPrimary = isRecording2 ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      // style: ElevatedButton.styleFrom(
      //   // 設定 Icon 大小及屬性
      //   minimumSize: const Size(175, 50),
      //   primary: primary,
      //   onPrimary: onPrimary,
      // ),
      style: ElevatedButton.styleFrom(
        primary: primary,
        onPrimary: Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(43),
      ),
      icon: Icon(icon),
      label: Text(
        text,
        // 設定字體大小及字體粗細（bold粗體，normal正常體）
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      // 當 Iicon 被點擊時執行的動作
      onPressed: () async {
        // getTemporaryDirectory(): 取得暫存資料夾，這個資料夾隨時可能被系統或使用者操作清除
        Directory tempDir = await path_provider.getTemporaryDirectory();
        // define file directory
        String path = '${tempDir.path}/SpeechRecognition.wav';
        // 控制開始錄音或停止錄音
        await recorder2.toggleRecording(path);
        // When stop recording, pass wave file to socket
        if (!recorder2.isRecording) {
          //   if (recognitionLanguage == "Taiwanese") {
          // if recognitionLanguage == "Taiwanese" => use Minnan model
          // setTxt is call back function
          // parameter: wav file path, call back function, model
          // await Speech2Text().connect(path, setTxt, "Minnan");
          // glSocket.listen(dataHandler, cancelOnError: false);
          // } else {
          // if recognitionLanguage == "Chinese" => use MTK_ch model
          await Speech2Text().connect(path, setTxt, "MTK_ch");
          // }
        }
        // set state is recording or stop
        setState(() {
          recorder2.isRecording;
        });
      },
    );
  }

  Widget confirmbutton() {
    final text = '確認';
    final icon = Icons.check;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        // 設定 Icon 大小及屬性
        minimumSize: const Size(180, 60),
        primary: Colors.blue[700],
        // primary: primary,
        onPrimary: Colors.white,
      ),

      icon: Icon(icon),
      label: Text(
        text,
        // 設定字體大小及字體粗細（bold粗體，normal正常體）
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      // 當 Iicon 被點擊時執行的動作
      onPressed: () {
        Clipboard.setData(ClipboardData(text: initInput)); // copy text
        setState(() {});
      },
    );
  }

  Widget backspacebutton() {
    final text = '返回';
    final icon = Icons.backspace;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        // 設定 Icon 大小及屬性
        minimumSize: const Size(180, 60),
        primary: Colors.black87,
        // primary: primary,
        onPrimary: Colors.white,
      ),

      icon: Icon(icon),
      label: Text(
        text,
        // 設定字體大小及字體粗細（bold粗體，normal正常體）
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      // 當 Iicon 被點擊時執行的動作
      onPressed: () {
        initInput = initInput.substring(0, initInput.length - 1);
        setState(() {});
      },
      onLongPress: () {
        initInput = '';
        setState(() {});
      },
    );
  }

  Widget speakbutton() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(Icons.help),
        iconSize: 45.0,
        splashRadius: 45.0,
        onPressed: () async {
          // 得到 TextField 中輸入的 value
          String strings =
              "按下台語鍵可以把台語轉成文字，按下國語鍵可以把國語轉成文字，返回鍵可以刪除文字，確認鍵可以複製所有文字";
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

  Widget commabutton(){
    // return TextButton(
    //   child: Text('，'),
    //   style: TextButton.styleFrom(
    //     primary: Colors.black38,
    //     textStyle: TextStyle(fontSize: 50.0),
    //   ),
    //   onPressed: () {
    //     initInput = initInput + '，';
    //     setState(() {});
    //   },
    // );
    return ElevatedButton(
      child: Text('，'),
      style: ElevatedButton.styleFrom(
        // 設定 Icon 大小及屬性
        minimumSize: const Size(70, 70),
        primary: Colors.black45,
        // primary: primary,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(fontSize: 35.0),
      ),

      onPressed: () {
        // initInput = initInput.substring(0, initInput.length - 1);
        initInput = initInput + '，';
        setState(() {});
      },
    );
  }
  Widget periodbutton(){
    return ElevatedButton(
      child: Text('。'),
      style: ElevatedButton.styleFrom(
        // 設定 Icon 大小及屬性
        minimumSize: const Size(70, 70),
        primary: Colors.black45,
        // primary: primary,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(fontSize: 35.0),
      ),

      onPressed: () {
        // initInput = initInput.substring(0, initInput.length - 1);
        initInput = initInput + '。';
        setState(() {});
      },
    );
  }
  Widget comma1button(){
    return ElevatedButton(
      child: Text('、'),
      style: ElevatedButton.styleFrom(
        // 設定 Icon 大小及屬性
        minimumSize: const Size(70, 70),
        primary: Colors.black45,
        // primary: primary,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(fontSize: 35.0),
      ),

      onPressed: () {
        // initInput = initInput.substring(0, initInput.length - 1);
        initInput = initInput + '、';
        setState(() {});
      },
    );
  }
  Widget exclamationbutton(){
    return ElevatedButton(
      child: Text('!'),
      style: ElevatedButton.styleFrom(
        // 設定 Icon 大小及屬性
        minimumSize: const Size(70, 70),
        primary: Colors.black45,
        // primary: primary,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(fontSize: 35.0),
      ),

      onPressed: () {
        // initInput = initInput.substring(0, initInput.length - 1);
        initInput = initInput + '!';
        setState(() {});
      },
    );
  }
  Widget questionbutton(){
    return ElevatedButton(
      child: Text('?'),
      style: ElevatedButton.styleFrom(
        // 設定 Icon 大小及屬性
        minimumSize: const Size(70, 70),
        primary: Colors.black45,
        // primary: primary,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(fontSize: 35.0),
      ),

      onPressed: () {
        // initInput = initInput.substring(0, initInput.length - 1);
        initInput = initInput + '?';
        setState(() {});
      },
    );
  }
  Widget tildebutton(){
    return ElevatedButton(
      child: Text('~'),
      style: ElevatedButton.styleFrom(
        // 設定 Icon 大小及屬性
        minimumSize: const Size(70, 70),
        primary: Colors.black45,
        // primary: primary,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(fontSize: 35.0),
      ),

      onPressed: () {
        // initInput = initInput.substring(0, initInput.length - 1);
        initInput = initInput + '~';
        setState(() {});
      },
    );
  }
  // set recognitionController.text function
  void setTxt(taiTxt) async{
    recognitionController.text = taiTxt;
    String? result = await TtoC(taiTxt);
    // initInput = initInput + recognitionController.text;
    if(recorder1.isRecording)
      initInput = initInput + recognitionController.text;
    else
      initInput = initInput + result!;
    setState(() {});
  }

  Widget buildTaiwaneseField(txt) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextField(
        controller: taiwanessController, // 為了獲得TextField中的value
        decoration: InputDecoration(
          fillColor: Colors.white,
          // 背景顏色，必須結合filled: true,才有效
          filled: true,
          // 重點，必須設定為true，fillColor才有效
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)), // 設定邊框圓角弧度
            borderSide: BorderSide(
              color: Colors.black87, // 設定邊框的顏色
              width: 2.0, // 設定邊框的粗細
            ),
          ),
          // when user choose the TextField
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red, // 設定邊框的顏色
                width: 2, // 設定邊框的粗細
              )),
          hintText: txt,
          // 提示文字
          suffixIcon: IconButton(
            // TextField 中最後可以選擇放入 Icon
            icon: const Icon(
              Icons.search, // Flutter 內建的搜尋 icon
              color: Colors.grey, // 設定 icon 顏色
            ),
            // 當 Iicon 被點擊時執行的動作
            onPressed: () async {
              // 得到 TextField 中輸入的 value
              String strings = taiwanessController.text;
              // 如果為空則 return
              if (strings.isEmpty) return;
              // connect to text2speech socket
              // The default is man voice.
              // If you want a female's voice, put "female" into the parameter.
              // parameter: call back function, speech synthesized text, (female)
              await Text2Speech().connect(play, strings, "female");
              // player.init();
              setState(() {
                // player.isPlaying;
              });
            },
          ),
        ),
      ),
    );
  }

  Future play(String pathToReadAudio) async {
    await player.play(pathToReadAudio);
    setState(() {
      player.init();
      player.isPlaying;
    });
  }

  Widget buildChineseField(txt) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextField(
        controller: chineseController,
        decoration: InputDecoration(
          filled: true,
          //重點，必須設定為true，fillColor才有效
          fillColor: Colors.white,
          //背景顏色，必須結合filled: true,才有效
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.black87, // 設定邊框的顏色
              width: 2.0, // 設定邊框的粗細
            ),
          ),
          // when user choose the TextField
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red, // 設定邊框的顏色
                width: 2, // 設定邊框的粗細
              )),
          hintText: txt,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: () async {
              String strings = chineseController.text;
              if (strings.isEmpty) return;
              print(strings);
              await Text2SpeechFlutter().speak(strings);
            },
          ),
        ),
      ),
    );
  }

  Widget buildOutputField() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: textBlock(),
    );
  }

  // Use to choose language of speech recognition
  String recognitionLanguage = "Taiwanese";
}

class textBlock extends StatefulWidget {
  const textBlock({
    Key? key,
  }) : super(key: key);

  @override
  State<textBlock> createState() => textBlockState();
}

class textBlockState extends State<textBlock> {
  String display = ' ';

  @override
  void initState() {
    super.initState();
  }

  renderText() {
    TextStyle style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 30.0,
      height: 1.5,
    );
    TextStyle styleDefault = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.grey[400],
      fontSize: 30.0,
      height: 1.5,
      letterSpacing: 1.5,
    );
    return Center(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(9.0),
          height: 340.0,
          width: 300.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: (Colors.grey[300])!,
              width: 3.0,
            ),
          ),
          child: Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  initInput == ''? '按按鈕來語音輸入': initInput,
                  style: initInput == ''? styleDefault: style,
                )),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // return renderText();
    return Column(
      children: [
        renderText(),
      ],
    );
  }
}