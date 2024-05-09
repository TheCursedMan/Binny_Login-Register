import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loginregister/Register.dart';

import 'Model/user.dart';
import 'UserProfile.dart';
import 'firebase_options.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  UserData myUser = UserData();
  final Future<FirebaseApp> firebase = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  CollectionReference _usercollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: firebase, builder: (context , snapshot){
      if(snapshot.hasError){
        print(snapshot.error);
        return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text('${snapshot.error}'))
        );
      }
      if(snapshot.connectionState == ConnectionState.done){
        return Scaffold(
          appBar: AppBar(
            title: Text('Binny(Mockup)'),
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'อีเมลล์',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      validator: MultiValidator([
                        EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                        RequiredValidator(errorText: 'กรุณาป้อนอีเมล')
                      ]),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (String? email) {
                        myUser.email = email;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'รหัสผ่าน',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: RequiredValidator(errorText: 'กรุณาป้อนรหัสผ่าน'),
                      onSaved: (String? password) {
                        myUser.password = password;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        child: Text('Login'),
                        onPressed: () async{
                          if (formKey.currentState!.validate()) {
                            formKey.currentState?.save();
                            try {
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: myUser.email as String,
                                    password: myUser.password as String
                                ).then((value) {
                                  formKey.currentState!.reset();
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(
                                      builder: (context) {
                                        return UserProfile();
                                      })
                                  );
                                });
                            }on FirebaseAuthException catch(e){
                              Fluttertoast.showToast(
                                  msg: e.message as String,
                                  gravity: ToastGravity.CENTER
                              );
                            }
                            formKey.currentState?.reset();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Center(
                      child: GestureDetector(
                        child: Text('หากยังไม่ลงทะเบียน คลิกที่นี่'),
                        onTap: (){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(
                              builder: (context) {
                                return RegisterPage();
                              })
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
      return Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    });
  }
}

