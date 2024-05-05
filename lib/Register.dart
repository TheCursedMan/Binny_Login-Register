import 'package:flutter/material.dart';
import 'package:loginregister/Model/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  User myUser = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onSaved: (String? email) {
                    myUser.email = email;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Birth Date',
                  style: TextStyle(fontSize: 20),
                ),
                TextFormField(
                  onSaved: (String? birthDate) {
                    myUser.birthDate = birthDate;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Gender',
                  style: TextStyle(fontSize: 20),
                ),
                TextFormField(
                  onSaved: (String? gender) {
                    myUser.gender = gender;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Password',
                  style: TextStyle(fontSize: 20),
                ),
                TextFormField(
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
                  validator: (value) {
                    if (value != myUser.password) {
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
                    onPressed: () {
                      formKey.currentState?.save();
                      print('${myUser.firstName}');
                      print('${myUser.lastName}');
                      print('${myUser.email}');
                      print('${myUser.birthDate}');
                      print('${myUser.gender}');
                      print('${myUser.password}');
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
}
