import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginregister/Model/user.dart';
import 'package:loginregister/login.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where('uid', isEqualTo: auth.currentUser!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No user data'),
                );
              }
              var userData =
                  snapshot.data!.docs[0].data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Container(
                              decoration:
                                  BoxDecoration(border: Border.all(width: 1)),
                            ),
                          ),
                          Text(
                            '   Hello ${userData['username']} !!',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading:
                          Text('First Name', style: TextStyle(fontSize: 17)),
                      title: Text(userData['firstname'].toString()),
                    ),
                    ListTile(
                      leading:
                          Text('Last Name', style: TextStyle(fontSize: 17)),
                      title: Text(userData['lastname'].toString()),
                    ),
                    ListTile(
                      leading: Text('Username', style: TextStyle(fontSize: 17)),
                      title: Text(userData['username'].toString()),
                    ),
                    ListTile(
                      leading: Text('Gender', style: TextStyle(fontSize: 17)),
                      title: Text(userData['gender'].toString()),
                    ),
                  ],
                ),
              );
            },
          ),
          Column(
            children: [
              Text(
                'ตรงนี้เอาไว้เช็ค mail:  ${auth.currentUser!.email as String} ',
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 20),
              Text('uid :  ${auth.currentUser!.uid}',
                  style: TextStyle(fontSize: 17))
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                auth.signOut().then((value) => {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }))
                    });
              },
              child: Text(
                'logout',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange
            ),
          ),
        ],
      ),
    );
  }
}
