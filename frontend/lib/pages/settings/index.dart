import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkme/pages/posted_spots/posted_spots_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/request_handlers/user_request.dart';
import '../login/login_page.dart';

// class SettingsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold;
//   }
// }

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool editing = false;
  bool imgSelected = false;
  dynamic initial;
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController license = TextEditingController();
  final picker = ImagePicker();
  String pfp = "";

  Future getImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response =
          await UserRequest().uploadPhoto(token, File(pickedFile!.path));
      print(response.statusCode);
      final data = jsonDecode(response.body);
      pfp = data[0];
      setState(() {
        imgSelected = true;
        editing = true;
      });
      print(data);
    } catch (e) {
      print(e);
    }
  }

  MaterialBanner errorBanner(String text) {
    Future.delayed(const Duration(milliseconds: 10),
        () => ScaffoldMessenger.of(context)..removeCurrentMaterialBanner());
    return MaterialBanner(
      padding: const EdgeInsets.all(20),
      content: Text(text),
      leading: const Icon(Icons.error),
      backgroundColor: Colors.red,
      actions: <Widget>[
        TextButton(
          style: const ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          ),
          onPressed: () =>
              {ScaffoldMessenger.of(context).hideCurrentMaterialBanner()},
          child: const Text('Dismiss'),
        ),
      ],
    );
  }

  MaterialBanner successBanner(String text) {
    return MaterialBanner(
      padding: const EdgeInsets.all(20),
      content: Text(text, style: const TextStyle(color: Colors.white)),
      leading: const Icon(Icons.check_circle, color: Colors.white),
      backgroundColor: Colors.green,
      actions: <Widget>[
        TextButton(
          style: const ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          ),
          onPressed: () =>
              {ScaffoldMessenger.of(context).hideCurrentMaterialBanner()},
          child: const Text('Dismiss'),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> preload() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final id = prefs.getString('id');

      final response = await UserRequest().getUser(token, id);
      final body = jsonDecode(response.body);
      return body['user'];
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<void> handleSubmit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final id = prefs.getString('id');
      dynamic data = {};
      if (name.text.isNotEmpty) data['name'] = name.text;
      if (email.text.isNotEmpty) data['email'] = email.text;
      if (phone.text.isNotEmpty) data['phone'] = phone.text;
      if (license.text.isNotEmpty) data['license'] = license.text;
      if (pfp.isNotEmpty) data['pfp'] = pfp;
      print(data);
      final response = await UserRequest().editUser(token, id, data);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
          ..removeCurrentMaterialBanner()
          ..showMaterialBanner(successBanner("Profile Saved!"));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
        ..removeCurrentMaterialBanner()
        ..showMaterialBanner(errorBanner("Error processing request"));
    }
    setState(() {
      imgSelected = false;
    });
  }

  void handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    await prefs.remove('token');
    await prefs.remove('id');
    if (!mounted) return;
    // if(context.mounted) return;
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: const LoginPage(),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  void handleCancel() {
    setState(() {
      editing = false;
    });
    name.text = initial['name'] ?? "";
    phone.text = initial['phone'] ?? "";
    license.text = initial['license'] ?? "";
    email.text = initial['email'] ?? "";
    pfp = initial['pfp'] ??
        "https://images.pexels.com/photos/633432/pexels-photo-633432.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";
    setState(() {
      imgSelected = false;
    });
  }

  void handleRoutePosted() {
    // PersistentNavBarNavigator.pushNewScreen(
    //   context,
    //   screen: const PostedSpots(),
    //   withNavBar: true, // OPTIONAL VALUE. True by default.
    //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // );
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const PostedSpots(),
        ));
  }

  void handleEdit() {
    setState(() {
      editing = true;
    });
  }

  Widget floatingButtons() {
    return Row(
      children: [
        SizedBox(width: 30),
        FloatingActionButton.extended(
          onPressed: () => handleCancel(),
          label: const Text('cancel'),
          icon: const Icon(Icons.cancel_sharp),
          backgroundColor: Colors.pink[300],
        ),
        Spacer(),
        FloatingActionButton.extended(
          onPressed: () => handleSubmit(),
          label: const Text('save'),
          icon: const Icon(Icons.check),
          backgroundColor: Colors.greenAccent,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 1,
        actions: [
          FloatingActionButton.extended(
            onPressed: () => handleRoutePosted(),
            label: const Text('my spots'),
            icon: const Icon(Icons.car_rental),
            backgroundColor: Colors.blue[400],
          ),
          Spacer(),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'logout',
            onPressed: () {
              handleLogout();
            },
          ),
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body: FutureBuilder(
        future: preload(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            name.text = snapshot.data['name'] ?? "";
            phone.text = snapshot.data['phone'] ?? "";
            license.text = snapshot.data['license'] ?? "";
            email.text = snapshot.data['email'] ?? "";
            initial = snapshot.data;
            if (!imgSelected) {
              pfp = snapshot.data['pfp'] ??
                  "https://images.pexels.com/photos/633432/pexels-photo-633432.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";
            }
            // print(name.text);
            // print(phone.text);
            // print(license.text);
            // print(email.text);
            // print(pfp);
            return Container(
              padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    const Text("Profile",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500)),
                    Center(
                        child: Stack(
                      children: [
                        Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 10)),
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(pfp),
                                ))),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => getImage(),
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: Colors.blue),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                )),
                          ),
                        )
                      ],
                    )),
                    const SizedBox(
                      height: 35,
                    ),
                    InputField(
                        label: "Full Name",
                        placeholder: "Full Name",
                        controller: name,
                        handleEdit: handleEdit),
                    InputField(
                        label: "Email",
                        placeholder: "Email",
                        controller: email,
                        handleEdit: handleEdit),
                    InputField(
                        label: "Phone Number",
                        placeholder: "(xxx)-xxx-xxxx",
                        controller: phone,
                        handleEdit: handleEdit),
                    InputField(
                        label: "License Plate",
                        placeholder: "License Plate",
                        controller: license,
                        handleEdit: handleEdit),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: editing ? floatingButtons() : Row(),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final Function handleEdit;
  InputField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    required this.handleEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 35.0),
      child: TextField(
        onTap: () => handleEdit(),
        controller: controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
    );
  }
}
