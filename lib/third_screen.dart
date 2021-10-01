import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_flash_chat/image_screen.dart';
import 'models.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThirdScreen extends StatefulWidget {
  final String uid;
  final String uMail;
  ThirdScreen({required this.uid,required this.uMail});

  @override
  _ThirdScreenState createState() => _ThirdScreenState();


}

class _ThirdScreenState extends State<ThirdScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async{
              await FirebaseAuth.instance.signOut();
              SharedPreferences _sharedPreferences =  await SharedPreferences.getInstance();
              _sharedPreferences.setBool('remembered', false);
              Navigator.of(context).pop();
          }, icon: Icon(Icons.clear,color: Colors.white,)),
          SizedBox(width: 10.0,)
        ],
        backgroundColor: Colors.lightBlue,
        title: Text('Chat',style: TextStyle(fontSize: 25.0),),
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
          child: Image.asset('images/flash.png',fit: BoxFit.fill,),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('messages').orderBy('messageId').snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                      strokeWidth: 2.0,
                    ),
                  );
                }
                if(snapshot.connectionState == ConnectionState.active) {
                  return ListView(
                    reverse: true,
                    children: snapshot.data!.docs.reversed.map(
                            (e) {
                              Message  message = Message(
                                isImage: e['isImage'],
                                messageId: e['messageId'],
                                  senderId: e['senderId'],
                                  content: e['content'],
                                  time: e['time'],
                                   senderMail: e['senderMail']
                              );
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment: (message.senderId == widget.uid)?MainAxisAlignment.end:MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:(message.senderId == widget.uid)?CrossAxisAlignment.end:CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                                bottomRight: (message.senderId == widget.uid)?Radius.zero:Radius.circular(20.0),
                                                bottomLeft: (message.senderId == widget.uid)?Radius.circular(20.0):Radius.zero
                                            ),
                                            color: (message.senderId == widget.uid)?Colors.blueAccent:Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Visibility(
                                                visible: (message.senderId != widget.uid),
                                                  child: Text(message.senderMail,style: TextStyle(color:Colors.blueAccent,fontSize: 16.0,fontWeight: FontWeight.bold),)),
                                              SizedBox(height: 2.0,),
                                              (message.isImage)?GestureDetector(
                                                onTap:(){
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ImageScreen(url: message.content, senderMail: message.senderMail)));
                                                },
                                                child: Container(
                                                  height: MediaQuery.of(context).size.height*0.3,
                                                  width: MediaQuery.of(context).size.width*0.4,
                                                  child: Image.network(message.content,fit: BoxFit.fill,),
                                                ),
                                              ):Container(
                                                width:MediaQuery.of(context).size.width*0.6,
                                                child: Text(message.content,
                                                  style: TextStyle(
                                                    color:(message.senderId == widget.uid)?Colors.white:Colors.grey,
                                                    fontSize: 18.0),),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                                          child: Text('${message.time}',style: TextStyle(color: Colors.lightBlue,fontSize: 16.0),),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                  );
                }else{
                  return Center(
                    child: Text('Waiting ..')
                  );

                  }
                }

            ),
          ),
          Container(
            width: double.infinity,
            height: 2.0,
            color: Colors.lightBlue,
          ),
          MessageBar(uid: widget.uid, uMail: widget.uMail)
        ],
      ),
    );
  }

@override
void initState()  {
  // TODO: implement initState
  super.initState();
}


}

class MessageBar extends StatefulWidget {
  final String uid;
  final String uMail;
  MessageBar({required this.uid,required this.uMail});
  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  int? _lastMessage ;
  TextEditingController _messageController = TextEditingController();
  bool _isImage = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [Expanded(child: Padding(
          padding: const EdgeInsets.only(left: 20.0,bottom: 12.0),
          child: TextField(
            onChanged: (val){
              if(val.isNotEmpty){
                setState(() {
                  _isImage = false;
                });
              }else{
                setState(() {
                  _isImage = true;
                });
              }
            },
            controller: _messageController,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText:'Type something ...'
            ),
          ),
        )),
          Padding(
            padding: const EdgeInsets.only(right: 12.0,bottom: 12.0),
            child:(_isImage)?IconButton(onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
              File file = File(result!.files.single.path!);
              String fileName = p.basename(file.path);
              Reference storageReference = FirebaseStorage.instance.ref().child('$fileName');
              TaskSnapshot snapshot = await storageReference.putFile(file);
              String url = await snapshot.ref.getDownloadURL();
              await FirebaseFirestore.instance.collection('messages').orderBy('messageId').get().then((value) {
                setState(() {
                  _lastMessage = value.docs.last['messageId'];
                });
              });
              await FirebaseFirestore.instance.collection('messages').add({
                'isImage': true,
                'senderId': widget.uid,
                'content': url,
                'time': DateFormat.EEEE().add_jm().format(DateTime.now()),
                'senderMail':widget.uMail,
                'messageId':_lastMessage!+1,
              });
            }, icon: Icon(Icons.camera_alt_outlined,color: Colors.lightBlue,))
                : TextButton(onPressed: () async {
              if(_messageController.text.isNotEmpty){
                await FirebaseFirestore.instance.collection('messages').orderBy('messageId').get().then((value) {
                  setState(() {
                    _lastMessage = value.docs.last['messageId'];
                  });
                });
                await FirebaseFirestore.instance.collection('messages').add({
                  'isImage':false,
                  'senderId': widget.uid,
                  'content': _messageController.text,
                  'time': DateFormat.EEEE().add_jm().format(DateTime.now()),
                  'senderMail':widget.uMail,
                  'messageId':_lastMessage!+1,
                });
                _messageController.clear();
              }
            }, child: Text('send',style:TextStyle(color: Colors.lightBlue,fontSize: 20.0) ,)),
          )
        ],
      ),
    );
  }
}

