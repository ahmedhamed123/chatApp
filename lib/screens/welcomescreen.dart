import 'package:chat/screens/registration_screan.dart';
import 'package:chat/screens/signin_screen.dart';
import 'package:flutter/material.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isloading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                height: 170,
                child: Image.asset('images/logo1.png'),
              ),
              Text("TextMe",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: Colors.tealAccent[400],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30,left: 30,right: 30),
            child: SizedBox(
              height: 55,

            child: TextButton(
              child:isloading
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(color: Colors.white,),
                    SizedBox(width: 24,),
                    Text("Please Wait...",style: TextStyle(
                      color: Colors.white,fontWeight: FontWeight.bold
                    ),
                    )
                  ],
                 )
              : Text(" Submit ",
                style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w600
                ),
              ),
              onPressed: ()async{
                if(isloading)return;
                setState(() {
                  isloading=true;
                });
                await Future.delayed(Duration(seconds: 2));
                setState(() {
                  isloading=false;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SigninScreen()));
              },
              style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff2e384b),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),

                  )
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}
