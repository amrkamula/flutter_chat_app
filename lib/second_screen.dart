import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_flash_chat/third_screen.dart';
import 'package:flutter_app_flash_chat/validators.dart';

class SecondScreen extends StatefulWidget {
  final int flag;
  SecondScreen({required this.flag});
  @override
  _SecondScreenState createState() => _SecondScreenState();
}


class _SecondScreenState extends State<SecondScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.2,
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.2,
               width: MediaQuery.of(context).size.width*0.4,
              child: Image.asset('images/flash.png',fit: BoxFit.fill,),
            ),
            SizedBox(
              height: 50.0,
            ),
            Form(
                key: _key,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0,right: 50.0,bottom: 10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 1.5,
                          )
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          validator: Validator.emailValidator,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            focusColor: Colors.blueAccent,
                            hintText: 'Enter your e-mail ..',
                            hintStyle: TextStyle(color: Colors.blueAccent),
                            border: InputBorder.none
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 1.5,
                            )
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          validator: Validator.passwordValidator,
                          obscureText: true,
                          decoration: InputDecoration(
                              focusColor: Colors.blueAccent,
                              hintText: 'Enter your password ..',
                              hintStyle: TextStyle(color: Colors.blueAccent),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                    )
                  ],
            )),
            SizedBox(height: 40.0,),
            (widget.flag==0)?GestureDetector(
              onTap: () async{
                  if(_key.currentState!.validate()){
                    try{
                      var credentials = await _auth.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                      _emailController.clear();
                      _passwordController.clear();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>ThirdScreen(uid: credentials.user!.uid,uMail: credentials.user!.email!,))
                      );
                    }catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${e.toString()}',style: TextStyle(color: Colors.white,fontSize: 22.0),),duration: Duration(seconds: 3),backgroundColor: Colors.blue,)
                      );
                    }
                  }
              },
              child: Container(
                width: MediaQuery.of(context).size.width*0.7,
                child: Card(
                  elevation: 10.0,
                  color: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 20.0,),),
                    ),
                  ),
                ),
              ),
            )
                :GestureDetector(
              onTap: () async{
                if(_key.currentState!.validate()){
                  try{
                    var credentials = await _auth.createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                    );
                    _emailController.clear();
                    _passwordController.clear();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>ThirdScreen(uid: credentials.user!.uid,uMail: credentials.user!.email!,))
                    );
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${e.toString()}',style: TextStyle(color: Colors.white),),duration: Duration(seconds: 3),backgroundColor: Colors.blue,)
                    );
                  }
                }

              },
              child: Container(
                width: MediaQuery.of(context).size.width*0.7,
                child: Card(
                  elevation: 10.0,
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Register',style: TextStyle(color: Colors.white,fontSize: 20.0,),),
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
