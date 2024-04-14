import 'package:flutter/material.dart';
import '../main.dart';

enum MessageType {
  User,
  Model,
}

class Message {
final String text;
final MessageType type;
final DateTime timestamp;

Message({
  required this.text,
  required this.type,
  required this.timestamp,
});

factory Message.fromJson(Map<String, dynamic> json) {
return Message(
text: json['text'],
type: json['type'] == 'user' ? MessageType.User : MessageType.Model,
timestamp: DateTime.parse(json['timestamp']),
);
}

Map<String, dynamic> toJson() {
return {
'text': text,
'type': type == MessageType.User ? 'user' : 'model',
'timestamp': timestamp.toIso8601String(),
};
}
}

class BubbleMessage extends StatelessWidget {
  final Message message;


  const BubbleMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bubbleColor = message.type == MessageType.User
        ? Colors.blueGrey
        : Colors.grey;
    Alignment alignment = message.type == MessageType.User
        ? Alignment.topRight
        : Alignment.topLeft;
    String Name = message.type == MessageType.User ? "You" : "DeskHelperAI";

    return Align(
      alignment: alignment,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Positioned the Name text to the very left
                Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                    Name,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Message container
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  // Adjust left padding as needed
                  child: Container(
                    key: ValueKey<int>(message.hashCode),
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}