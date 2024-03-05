import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBprbCsxY1_eaAYIyebp_gCkolpJY0hDlQ",
          appId: "1:395865258517:android:df68c6eb6db57f6ad7ec1c",
          messagingSenderId: "",
          projectId: "fir-cloud-a0aa3",
          storageBucket: "fir-cloud-a0aa3.appspot.com"));
  runApp(MaterialApp(
    home: FirebaseCrud(),
  ));
}

class FirebaseCrud extends StatefulWidget {
  @override
  State<FirebaseCrud> createState() => _FirebaseCrudState();
}

class _FirebaseCrudState extends State<FirebaseCrud> {
  var name_controller = TextEditingController();
  var email_controller = TextEditingController();
  late CollectionReference _userCollection;

  @override
  void initState() {
    _userCollection = FirebaseFirestore.instance.collection("user");
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              )),
          ElevatedButton(onPressed: (){addUser();
            }, child: Text("add adress")),
          StreamBuilder<QuerySnapshot>
            (stream: getUser(),
              builder:(context,snapshot){
              if (snapshot.hasError){
                return const CircularProgressIndicator();
              }
              final users=snapshot.data!.docs;
              return Expanded(
                child:ListView.builder(
                    itemCount:users.length,
                    itemBuilder:(context,index){
                  final user= users[index];
                  final userId=user.id;
                  final userName=user['name'];
                  final userEmail=user['email'];
                  return ListTile(
                    title: Text('$userName',style: TextStyle(fontSize: 20),),
                 subtitle: Text('$userEmail',style: TextStyle(fontSize: 20),),
                  trailing: Wrap(
                    children: [
                      IconButton(onPressed: (){
                        // editUser(UserId);
                      }, icon: Icon(Icons.edit)),
                      IconButton(onPressed: (){
                        // deleteUser(userId);
                      }, icon: Icon(Icons.delete)),

                    ],
                  ),);
                    })
              );
              })
        ],
      ),
    );
  }

  void addUser()async {
    return _userCollection.add({
      'name':name_controller.text,
      'email':email_controller.text

    }).then((value){
      print("user added successfully");
      name_controller.clear();
      email_controller.clear();
      
    });


  getUser() {}
}
