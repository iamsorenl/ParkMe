import 'package:flutter/material.dart';
import 'package:parkme/app/navigator.dart';
import 'package:parkme/pages/homepage/homepage.dart';
import '../create_account/create_account_page.dart';
import '../dev_home/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Create TextEditingController objects to handle input fields

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorText = "";
  // A function to handle input field errors

  void handleFieldInput() {
    setState(() {
      errorText = "";
    });
  }
  // A function to handle user login

  Future<void> login(String email, String password, context) async {
    // Send a POST request to the login endpoint with the provided email and password

    final response = await http.post(
        Uri.http('${dotenv.env['host']}:3000', "login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text,
          'password': passwordController.text
        }));
    print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      // If the response is successful, retrieve and store user data in SharedPreferences

      final Map data = jsonDecode(response.body);
      // HANDLE LOGIN
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', data['name']);
      await prefs.setString('token', data['token']);
      await prefs.setString('id', data['id']);
      // Navigate to the home page

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const App(),
          ));
    } else {
      setState(() {
        errorText = "Error logging in. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // A container for the page title

            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            // A container for the email input field

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (text) => handleFieldInput(),
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
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
                  labelText: 'Password',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Expanded(
                child: Container(
                    height: 55,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Sign In'),
                      onPressed: () => login(emailController.text,
                          passwordController.text, context),
                    )),

                //  {

                // print(emailController.text);
                // print(passwordController.text);
                // },
              ),
            ]),
            Row(
              // ignore: sort_child_properties_last
              children: <Widget>[
                const Text('Do not have an account?'),
                TextButton(
                  child: const Text(
                    'Create an Account',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const CreateAccountPage(),
                    ));
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  errorText,
                  style: const TextStyle(color: Colors.red),
                )),
          ],
        ),
      ),
    );
  }
}
