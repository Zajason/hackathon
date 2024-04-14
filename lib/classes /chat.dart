import 'package:flutter/material.dart';
import 'package:messenger/main.dart';
import 'package:messenger/screens/home_screen.dart';
import 'package:messenger/classes /messages.dart';


class Chat {
  final DateTime created;
  final List<Message> messages = [];

  Chat({required this.created});

}


