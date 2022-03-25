import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ChatScreen extends StatelessWidget {

  final Map<String ,dynamic >?userMap;
  final String? chatId;
  ChatScreen({this.userMap, this.chatId});
  final TextEditingController _message=TextEditingController();
  final TextEditingController controller =TextEditingController();
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  void sendMessage()async{
    if(_message.text.isNotEmpty){
      Map<String,dynamic>messages={
        'sendby': FirebaseAuth.instance.currentUser!.displayName!,
        'message': _message.text,
        "time": FieldValue.serverTimestamp(),
      };
     _message.clear();
      await _firestore.collection('chatroom').doc(chatId).collection('chats').add(messages);

    }else{
      print("Enter some text ");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: StreamBuilder<DocumentSnapshot>(
          stream:
          _firestore.collection("users").doc(userMap!['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(userMap!['name']),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),

        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_forward_ios,size: 35,color: Colors.white,))
        ],
      ),
      body: SafeArea(
     child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //---------------------
            Container(
              height: size.height/1 ,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('chatroom').doc(chatId).
                collection('chats').orderBy('time',descending: false).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder:(context,index){
                        Map<String,dynamic>map=snapshot.data!.docs[index].data() as Map<String,dynamic>;
                        return Container(
                          width: size.width,
                          alignment: map['sendby'] == FirebaseAuth.instance.currentUser!.displayName
                          ?Alignment.centerRight
                          :Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 14),
                            margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                            decoration: BoxDecoration(color: Colors.teal,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text(map['message'],style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            ),
                          ),


                        );
                        } );
                  }else
                    return Container();
                } ,
              ),
            ),
            //**********************
            Container(

              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextField(
                          controller: _message,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20
                            ),
                            hintText: 'Write your message here ',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue,
                                    width: 2
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal,
                                    width: 3
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15)
                                )
                            ),
                          ),
                        ),
                      )
                  ),
                  IconButton(onPressed: (){
                    sendMessage();
                  },
                      icon: const Icon(Icons.send,size: 35,)
                  )
                ],
              ),
            )
          ],
        ),
      ),),
    );
  }

}
