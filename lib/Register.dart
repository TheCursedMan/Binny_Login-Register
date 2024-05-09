import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loginregister/Model/user.dart';
import 'package:loginregister/UserProfile.dart';
import 'package:loginregister/firebase_options.dart';
import 'package:loginregister/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  UserData myUser = UserData();
  final Future<FirebaseApp> firebase = Firebase.initializeApp(
    // options: FirebaseOptions(
    //     apiKey: 'AIzaSyCNJDXUBJ6dSc2bK-VEL_qM-oEjN8ZjJbM',
    //     appId: '1:724364547352:android:90e07c8e87ad79ee8b7a6d',
    //     messagingSenderId: '724364547352',
    //     projectId: 'binnydb-c2557',
    //     storageBucket: 'binnydb-c2557.appspot.com'
    // ),
    options: DefaultFirebaseOptions.currentPlatform
  );

  CollectionReference _usercollection = FirebaseFirestore.instance.collection('users');
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  //date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != myUser.birthDate) {
      setState(() {
        myUser.birthDate = picked
            .toIso8601String()
            .substring(0, 10); // or format the picked date as needed
        _birthdateController.text = myUser.birthDate ?? '';
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    _passwordController.clear();
    _confirmpasswordController.clear();
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
                      'ชื่อ',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      validator: RequiredValidator(errorText: 'กรุณาป้อนชื่อ'),
                      onSaved: (String? firstName) {
                        myUser.firstName = firstName;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'นามสกุล',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      validator: RequiredValidator(errorText: 'กรุณาป้อนนามสกุล'),
                      onSaved: (String? lastName) {
                        myUser.lastName = lastName;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Username',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      validator: RequiredValidator(errorText: 'กรุณาป้อน username'),
                      onSaved: (String? username) {
                        myUser.username = username;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Email',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      validator: MultiValidator([
                        EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                        RequiredValidator(errorText: 'กรุณาป้อนอีเมล')
                      ]),
                      onSaved: (String? email) {
                        myUser.email = email;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Birth Date',
                      style: TextStyle(fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _birthdateController,
                          keyboardType: TextInputType.none,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your birth date';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.calendar_month)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Gender',
                      style: TextStyle(fontSize: 20),
                    ),
                    DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text('Select Option' , style: TextStyle(color: Colors.grey),),
                            enabled: false,
                          ),
                          DropdownMenuItem<String>(
                            value: 'male',
                            child: Text('male'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'female',
                            child: Text('female'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'other',
                            child: Text('other'),
                          ),
                        ],
                        validator: (value){
                          if(value == null){
                            return 'กรุณาเลือกเพศ';
                          }
                        },
                        onChanged: (String? newValue) {
                          setState(() {
                            myUser.gender = newValue!;
                          });
                        }),
                    ///////////////////////////////////////////////
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Password',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      validator: RequiredValidator(errorText: 'กรุณาป้อนรหัสผ่าน'),
                      onSaved: (String? password) {
                        myUser.password = password;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Confirm Password',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      controller: _confirmpasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Password not same';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
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
                        child: Text('ลงทะเบียน'),
                        onPressed: () async{
                          if (formKey.currentState!.validate() || true) {
                            formKey.currentState?.save();
                            await _usercollection.add({
                              "firstname" : myUser.firstName,
                              "lastname" : myUser.lastName,
                              "username" : myUser.username,
                              "email" : myUser.email,
                              "birthdate" : myUser.birthDate,
                              "gender" : myUser.gender,
                              "password" : myUser.password
                            });
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                  email: myUser.email as String,
                                  password: myUser.password as String
                              );
                              //very important for use try catch it maybe clear null
                              try {
                                _passwordController.clear();
                                _confirmpasswordController.clear();
                                _birthdateController.clear();
                                formKey.currentState!.reset();
                              }catch(ex){
                                print(ex);
                              }
                              Fluttertoast.showToast(
                                  msg: 'สร้างบัญชีผู้ใช้งานสำเร็จ',
                                  gravity: ToastGravity.CENTER
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            }on FirebaseAuthException catch(e){
                                  String? message;
                                  if(e.code == 'email-already-in-use'){
                                      message = 'มีอีเมลล์นี้ในระบบแล้ว โปรดเลือกใช้อีเมลล์อื่นแทน';
                                  }
                                  else if(e.code == 'weak-password'){
                                      message = 'กรุณาตั้งรหัสผ่านด้วยตัวใหญ่อย่างน้อย 1 ตัว และมีความยาวไม่น้อยกว่า 6 ตัว';
                                  }
                                  Fluttertoast.showToast(
                                    msg: message != null ? message : e.message as String  ,
                                    gravity: ToastGravity.CENTER
                                  );
                            }
                          }
                        },
                      ),
                    ),
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
