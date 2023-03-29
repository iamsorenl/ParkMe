import 'package:flutter/material.dart';
import 'package:parkme/app/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

//PAGES
import '../../components/create_listing/index.dart';
import '../homepage/homepage.dart';
import '../available_spots/available_spots_page.dart';
import 'package:parkme/pages/login/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = '';
  String token = '';
  void __nameRetriever() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenPref = prefs.getString('token');
    final namePref = prefs.getString('name');
    if (tokenPref == null || namePref == null) {
      handleLogout();
    } else {
      setState(() {
        name = (prefs.getString('name') ?? '');
        token = (prefs.getString('token') ?? '');
      });
    }
  }

  void handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    await prefs.remove('token');
    await prefs.remove('id');
    if (!mounted) return;
    // if(context.mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginPage(), fullscreenDialog: true));
  }

  @override
  void initState() {
    super.initState();
    __nameRetriever();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () => handleLogout(),
                child: const Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: <Widget>[
          // const SizedBox(height: 20),
          // Container(
          //     height: 50,
          //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          //     child: ElevatedButton(
          //         child: const Text('Create Spot'),
          //         onPressed: () => Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (BuildContext context) =>
          //                     const CreateSpotPage(),
          //                 fullscreenDialog: true)))),
          // const SizedBox(width: 8),
          // Container(
          //     height: 50,
          //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          //     child: ElevatedButton(
          //         child: const Text('View Available Spots'),
          //         onPressed: () => Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (BuildContext context) =>
          //                     const AvailableSpotsPage(),
          //                 fullscreenDialog: true)))),
          // Container(
          //     height: 50,
          //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          //     child: ElevatedButton(
          //         child: const Text('View Profile Page'),
          //         onPressed: () => Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (BuildContext context) =>
          //                     const ProfilePage(),
          //                 fullscreenDialog: true)))),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                  child: const Text('View Homepage (Map with Search Bar)'),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const App(),
                          fullscreenDialog: true)))),
        ]),
      ),
      // bottomNavigationBar: const AppBottomNav()
      // BottomNavigationBar(
      // items: [
      //   BottomNavigationBarItem(
      //     icon: Icon(Icons.home),
      //     label: 'Home',
      //   ),
      //   BottomNavigationBarItem(
      //     icon: Icon(Icons.business),
      //     label: 'Business',
      //   ),
      //   BottomNavigationBarItem(
      //     icon: Icon(Icons.school),
      //     label: 'School',
      //   ),
      // ],
      // ),
    );
  }
}
