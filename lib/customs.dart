import 'package:flutter/material.dart';
import 'package:flutter_app_flash_chat/second_screen.dart';

class CustomButton extends StatelessWidget {
  final String txt;
  final Color color;
  final int flag;

  CustomButton({required this.txt,required this.color,required this.flag});
@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: (){
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=> SecondScreen(flag:this.flag))
      );
    },
    child: Container(
      width: MediaQuery.of(context).size.width*0.7,
      child: Card(
        elevation: 10.0,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(txt,style: TextStyle(color: Colors.white,fontSize: 20.0,),),
          ),
        ),
      ),
    ),
  );
}
}
