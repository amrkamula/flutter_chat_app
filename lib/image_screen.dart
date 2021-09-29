import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String url;
  final String senderMail;
  ImageScreen({required this.url,required this.senderMail});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black54,
        title: Text(senderMail,style: TextStyle(
          color: Colors.white,
          fontSize: 20.0
        ),),
      ),
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height*0.7,
          width: MediaQuery.of(context).size.width*0.9,
          child: Image.network(url,fit: BoxFit.fill,),
        ),
      ),
    );
  }
}
