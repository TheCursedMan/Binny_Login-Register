import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loginregister/Model/user.dart';
import 'package:loginregister/firebase_options.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  User myUser = User();
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
      });
    }
  }

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
                          controller:
                              TextEditingController(text: myUser.birthDate ?? ''),
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your birth date';
                            }
                            return null;
                          },
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
                      obscureText: true,
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
                          if (formKey.currentState!.validate()) {
                            formKey.currentState?.save();
                            print('${myUser.firstName}');
                            print('${myUser.lastName}');
                            print('${myUser.email}');
                            print('${myUser.birthDate}');
                            print('${myUser.gender}');
                            print('${myUser.password}');
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
