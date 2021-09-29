import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'customs.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainScreen(),
  ));
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void initialize() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    initialize();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.2,
                height: MediaQuery.of(context).size.height*0.1,
                child: Image.asset('images/flash.png',fit: BoxFit.fill,),
              ),
              Text('Flash chat',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 40.0),),
            ],
          ),
          SizedBox(height: 50.0,),
          CustomButton(txt: 'Login', color: Colors.lightBlue,flag:0),
          SizedBox(height: 20.0,),
          CustomButton(txt: 'Register', color: Colors.blueAccent,flag: 1,),
        ],
      ),
    );
  }
}


