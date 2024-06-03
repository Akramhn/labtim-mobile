import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:labtim_mobile/model/userModel/userModel.dart';
import 'package:labtim_mobile/screen/home/home.dart';
import 'package:labtim_mobile/widgets/customTextField.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

//etat cv
class _ProfileState extends State<Profile> {
  String err = "";

  void register(String name, String email, String pass, String id) async {
    setState(() {
      err = "";
    });
    try {
      var url = Uri.https('labtim.000webhostapp.com', 'labtim_mob/profile.php');
      final response = await http.post(url,
          body: {"name": name, "email": email, "pass": pass, "id": id});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var result = data['data'];

        int sucess = result[1];
        if (sucess == 1) {
          setState(() async {
            err = result[0];

            UserModel user = UserModel.fromJson(result[2]);
            UserModel.saveUser(user);
            UserModel.sessionUser = user; // Set the session user
          });
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  CustomTextField emailText = CustomTextField(
    title: UserModel.sessionUser!.email,
    placeholder: "Enter your email",
    prefixIcon: Icons.email,
  );

  CustomTextField nameText = CustomTextField(
    title: UserModel.sessionUser!.nom,
    placeholder: "Enter your name",
    prefixIcon: Icons.person,
  );
  CustomTextField passText = CustomTextField(
    title: "Password",
    placeholder: "Enter your password",
    ispass: true,
    prefixIcon: Icons.lock,
  );
  CustomTextField confirmPassText = CustomTextField(
    title: "Confirm Password",
    placeholder: "Confirm password",
    ispass: true,
    prefixIcon: Icons.lock,
  );
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    emailText.err = "Enter Email";
    passText.err = "Enter Password";
    confirmPassText.err = "Confirm Password";
    nameText.err = "Enter your name";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical App Profile'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with opacity
          Opacity(
            opacity: 0.8,
            child: Image.asset(
              'assets/images/background_image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
              child: Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _key,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_pharmacy,
                            size: 80,
                            color: Colors.blue.shade800,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Welcome to Your Medical App",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(height: 30),
                          nameText.textFormField(),
                          const SizedBox(height: 30),
                          emailText.textFormField(),
                          const SizedBox(height: 20),
                          passText.textFormField(),
                          const SizedBox(height: 20),
                          confirmPassText.textFormField(),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.lightBlue.shade400,
                                  Colors.blue.shade800,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  if (passText.value == confirmPassText.value) {
                                    register(
                                      nameText.value,
                                      emailText.value,
                                      passText.value,
                                      UserModel.sessionUser!.id,
                                    );

                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => Home(
                                                login: () {},
                                              )), // Replace HomePage() with your actual home page widget
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Error',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: const Text(
                                            'Passwords do not match.',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.app_registration),
                                  SizedBox(width: 10),
                                  Text(
                                    'Profile',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            err,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 107, 8, 1)),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    // Existing submit form logic
  }

  void _onMenuItemSelected(BuildContext context, String value) {
    switch (value) {
      case 'Login':
        break;
      case 'about':
        _showSnackBar(context, 'About clicked');
        break;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Existing emailTextFormField and passTextFormField methods
}
