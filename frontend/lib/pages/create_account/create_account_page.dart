import 'package:flutter/material.dart';
import '../login/login_page.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  // email & password
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // name
  TextEditingController nameController = TextEditingController();

  String errorText = "";

  void handleFieldInput() {
    setState(() {
      errorText = "";
    });
  }

  Future<void> createAccount(String email, String password, context) async {
    final response = await http.post(Uri.http('localhost:3000', "user"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text,
          'password': passwordController.text,
          'name': nameController.text
        }));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      // final Map data = jsonDecode(response.body);
      // HANDLE CREATE ACCOUNT
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('name', data['name']);
      // await prefs.setString('token', data['token']);
      print(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage(),
          ));
    } else {
      setState(() {
        errorText = "Error creating account. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('ParkMe'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (text) => handleFieldInput(),
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Name',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (text) => handleFieldInput(),
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Email: "example@email.com"',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    onChanged: (text) => handleFieldInput(),
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New Password',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                        child: const Text('Create Account'),
                        onPressed: () => createAccount(emailController.text,
                            passwordController.text, context) //{
                        //print(emailController.text);
                        //print(passwordController.text);
                        //},
                        )),
              ],
            )));
  }
}
