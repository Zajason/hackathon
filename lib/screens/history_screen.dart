import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:messenger/classes /messages.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? selectedDate;
  List<Message> messages = [];
  String? getUser(Message message){
    if(message.type == MessageType.User){
      return 'You:';
    }
    else{
      return 'ASSISTANT:';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: Text('Chat History'),
        backgroundColor: Colors.white12,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today,color: Colors.white,),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${getUser(messages[index])}${messages[index].text}',style: TextStyle(color: Colors.white),),
            subtitle: Text(messages[index].timestamp.toString(),style: TextStyle(color: Colors.white),),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      barrierColor: Colors.blueGrey,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),

    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      loadChatHistory();
    }
  }

  Future<void> loadChatHistory() async {
    if (selectedDate == null) return;

    String dateKey = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$dateKey-chat-history.json');

    if (await file.exists()) {
      String content = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(content);
      setState(() {
        messages = jsonData.map((data) => Message.fromJson(data)).toList();
      });
    } else {
      setState(() {
        messages = [];
      });
    }
  }
}


