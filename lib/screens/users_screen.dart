import 'package:chat/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
   Map<String,dynamic>?userMap;
  bool isload=false;
  final TextEditingController _searchController=TextEditingController();
   FirebaseFirestore _firestore= FirebaseFirestore.instance;
   User? signedInUser;


   @override
   void initState() {
     super.initState();
     getuser();
   }
   void getuser(){
     try {
       final user = FirebaseAuth.instance.currentUser;
       if (user != null) {
         signedInUser = user;
         print(signedInUser!.email);
       }
     }catch(e){
       print(e);
     }
   }
String chatId(String user1,String user2){
     if(user1[0].toLowerCase().codeUnits[0] > user2[0].toLowerCase().codeUnits[0]){
       return "$user1 $user2";
     }
     else
       return "$user1 $user2";
}
  void _onSearch()async{
    setState(() {
      isload=true;
    });
    await _firestore.collection('users').where('name',isEqualTo: _searchController.text).get().then((value) {
      setState(() {
        userMap=value.docs[0].data();
        isload=false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Image.asset('images/logo1.png',height: 35,),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('TextMe'),
              )
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          }, icon: const Icon(Icons.logout,size: 35,color: Colors.white,))
        ],

      ),
      body:isload
        ?Center(
        child: Container(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(),
        ),
      )
      :Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 150,

              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                      onTap: (){
                        _onSearch();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.search,size: 50,),
                      )),
                  hintText: "search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
              ),
            ),
            userMap!=null
                ? ListTile(
                 onTap: (){
                   String roomId =chatId(FirebaseAuth.instance.currentUser!.displayName!,
                       userMap!['name']);
                   Navigator.of(context).push(
                     MaterialPageRoute(builder: (_)=>ChatScreen(
                       chatId: roomId,
                       userMap: userMap!,
                     ))
                   );
                 },
              leading: Icon(Icons.account_box,color: Colors.teal,),
                title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(userMap!['name']),
                ),
                subtitle: Text(userMap!['email']),
                trailing: Icon(Icons.chat,color: Colors.teal[900],),

            ):Container()
          ],
        ),
      ),
    );
  }
}
