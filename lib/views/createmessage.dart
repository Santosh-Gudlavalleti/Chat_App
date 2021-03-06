import 'package:chat_app/apis/api.dart';
import 'package:chat_app/listings/chat_insert.dart';
import 'package:chat_app/views/chats.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

class CreateMessage extends StatefulWidget {
  final String source;

  CreateMessage({this.source});
  @override
  _CreateMessageState createState() => _CreateMessageState();
}

class _CreateMessageState extends State<CreateMessage> {
  final myController = TextEditingController();
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  ChatService get chatService => GetIt.I<ChatService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Send Message'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 30.0),
                Container(
                  child: Text(
                    "${widget.source}, Tell Something",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 24),
                  ),
                ),
                SizedBox(height: 30.0),
                TextField(
                  decoration: InputDecoration(hintText: "Enter the Message"),
                  controller: myController,
                ),
                SizedBox(height: 30.0),
                RaisedButton(
                  child: Text(
                    "Send",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if (myController.text != "") {
                      final notes = ChatInsert(
                          chatMessage: myController.text,
                          chatTitle: widget.source);

                      final result = await chatService.createChat(notes);

                      final title = 'Done';
                      final text = result.error
                          ? (result.errorMessage ?? 'An error has occured')
                          : 'Message has been sent';

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text(title),
                                content: Text(text),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(
                                                context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) => Chats(
                                                        source: widget.source)),
                                                (Route<dynamic> route) =>
                                                    false);
                                      },
                                      child: Text('OK'))
                                ],
                              )).then((data) {
                        if (result.data) {
                          Navigator.of(context).pop();
                        }
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "No Message",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.grey[800],
                          textColor: Colors.lightBlue,
                          fontSize: 14.0);
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
