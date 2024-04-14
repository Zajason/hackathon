
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../classes /messages.dart';
import 'history_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  List<Message> messages = [];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      key: _scaffoldKey,
      appBar: AppBar(
        title:  Row(mainAxisAlignment:MainAxisAlignment.center,children:[Text('PedroAI', style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),),SizedBox(width:20),
        CupertinoButton(onPressed:(){
          saveChatHistory(messages);
          setState(() {
            messages.clear();
          });


        },
            child:Image(image: AssetImage('lib/assets/images/pedro.png'),height: 40,width: 40,))]),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Container(color: Colors.white,height: 0.5,width: MediaQuery.of(context).size.width),

          messages.isEmpty
              ?  Container(height:MediaQuery.sizeOf(context).height*0.75,child:const Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(textAlign: TextAlign.center,
            'You an ask Pedro things like : What can I do to help the environment?',
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),

          ),
            Icon(Icons.forest,color: Colors.white,weight: 0.2,)
         ] )))
              :
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return BubbleMessage(message: messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color:Colors.blueGrey[400]),child:  Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _controller,
                    decoration: const InputDecoration(hintText: ' Type your message...', hintStyle: TextStyle(color: Colors.white),border: InputBorder.none),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          ),),
          const SizedBox(height: 10,)
        ],
      ),
      drawer: Drawer(child: HistoryScreen(),backgroundColor: Colors.blueGrey[900]),
    );
  }

  Future<void> sendMessage() async {
    var url = Uri.parse('http://10.0.0.59:1234/v1/chat/completions');
    String userMessage = _controller.text.trim();
    DateTime timestamp = DateTime.now();

    if (userMessage.isNotEmpty) {
      setState(() {
        messages.add(Message(text: userMessage, type: MessageType.User, timestamp: DateTime.now()));
        _controller.clear();
      });
      saveChatHistory(messages);
    }



    var body = jsonEncode({
      "messages": [
        {"role": "system", "content": "answer concisely and accurately"},
        {"role": "user", "content": userMessage}
      ],
      "temperature": 0,
      "max tokens": -1,
      "stream": false,
    });

    try {
      var response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var choices = data['choices'] as List<dynamic>;
        if (choices.isNotEmpty) {
          var message = choices[0]['message'] as Map<String, dynamic>?;
          var content = message?['content'];
          if (content != null) {
            setState(() {
              messages.add(Message(text: content.toString(), type: MessageType.Model, timestamp: DateTime.now()));
              saveChatHistory(messages);
            });
          }
        }
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> saveChatHistory(List<Message> messages) async {
    String dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$dateKey-chat-history.json');
    List<Map<String, dynamic>> jsonMessages = messages.map((message) => message.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonMessages));
  }

  Future<List<Message>> loadChatHistory(String dateKey) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$dateKey-chat-history.json');
    if (await file.exists()) {
      String content = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(content);
      List<Message> messages = jsonData.map((data) => Message.fromJson(data)).toList();
      return messages;
    }
    return [];
  }
}
