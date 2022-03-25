import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final firestore=FirebaseFirestore.instance;
  bool isHiddenPassword=true;
  String _email="";
  String _password="";
  String _username="";

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
                onChanged: (value)=>_email=value,
                validator: EmailValidator(errorText: "The email is invalid"),

                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email,color: Colors.teal,),
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
                onChanged: (value)=>_username=value,
                validator: (value){
                  if(value!.isEmpty){
                    return "Please Enter User Name";
                  }
                   return null;
                },

                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_sharp,color: Colors.teal,),
                  hintText: 'Enter User Name',
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
                onChanged: (value)=>_password=value,
                validator: MinLengthValidator(7, errorText:"password must be at least 7 characters "),

                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock,color: Colors.teal,),
                  suffixIcon: InkWell(
                    onTap: (){
                      setState(() {
                        isHiddenPassword =!isHiddenPassword;
                      });
                    },
                      child: const Icon(Icons.visibility)
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
                      if (_key.currentState!.validate()) {
                        print("Data is Not Empty ");
                        try {
                          final newUser = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email: _email,
                              password: _password);
                          if(newUser != null)
                          {
                            newUser.user!.updateDisplayName(_username);
                            await firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).set({
                              'name':_username,
                              'email':_email,
                              'status':'unavilable'
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>UserScreen()));
                          }
                        }
                        catch(e){
                          print(e);
                        }
                      } else {
                        print("Data is Empty ");
                      }

                    },

                    child: const Text(" register ",
                      style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff2e384b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),

                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

}
