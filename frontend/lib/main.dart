import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parkme/app/navigator.dart';
import 'package:parkme/pages/homepage/homepage.dart';
import 'package:parkme/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  await dotenv.load();
  runApp(MyApp());
}

class AuthService {
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenPref = prefs.getString('token');
    final namePref = prefs.getString('name');
    return tokenPref != null && namePref != null;
  }
}

// Step 4: Add user authentication check to the main screen

class MyApp extends StatelessWidget {

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          return false;
        }
        return true;
      },
      child: MaterialApp(
        title: "ParkMe",
        // theme: ThemeData.dark(),
        home: HomeMix(),
      )
    );
  }
}

class HomeMix extends StatelessWidget {
  final AuthService _authService = AuthService();
  HomeMix({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasData && snapshot.data!) {
          return const App();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
