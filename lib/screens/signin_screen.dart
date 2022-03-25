import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/registration_screan.dart';
import 'package:chat/screens/users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isHiddenPassword=true;
  bool _islogin=false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                child: Image.asset('images/logo1.png'),
              ),
              const SizedBox(height: 30),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email=value,
                validator: EmailValidator(errorText: "The email is invalid"),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email,color: Color(0xff2e384b)),
                  hintText: 'Enter Your Email',
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,
                          width: 1
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal,
                          width: 2
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)
                      )
                  ),
                ),
              ),
              const SizedBox(height:10 ),
              TextFormField(
                obscureText: isHiddenPassword,
                onChanged: (value)=>password=value,
                validator: (value){
                  if(value!.isEmpty ||value.length<7){
                    return "Enter a valid Password ";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock,color: Color(0xff2e384b)),
                  suffixIcon: InkWell(
                      onTap: (){
                        setState(() {
                          isHiddenPassword =!isHiddenPassword;
                        });
                      },
                      child: const Icon(Icons.visibility_outlined,color: Color(0xff2e384b))
                  ),
                  hintText: 'Enter Password',
                  contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,
                          width: 1
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal,
                          width: 2
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                child: SizedBox(
                  height: 50,
                  child: TextButton(

                    onPressed: ()async{
                      if (_key.currentState!.validate()){
                        print("Data is Not Empty ");
                        try {
                          final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>UserScreen()));
                          }
                          setState(() {
                            _islogin = false;
                          });
                        } catch (e) {
                          print(e);
                        }
                      }
                      else {
                        print("Data is Empty ");
                      }
                    },

                    child: const Text(" Log in ",
                      style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),

                        )
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
               InkWell(
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
                 } ,
                child: Row(
                  children: [
                    const Text("Don't have an account? ",
                  style: TextStyle(
                      color:Color(0xff2e384b),
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  )
                    ),
                    Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2.0,
                              color: Colors.teal
                            )
                          )
                        ),
                        child: const Text("Create a New Account ",
                          style: TextStyle(
                            color:Color(0xff004d40),
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}