import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:labtim_mobile/widgets/customTextField.dart';
import 'package:http/http.dart' as http;
import 'package:labtim_mobile/widgets/loding.dart';

class Registre extends StatefulWidget {
  final Function visible;
  const Registre(this.visible, {super.key});

  @override
  _RegistreState createState() => _RegistreState();
}

//etat cv
class _RegistreState extends State<Registre> {
  String err = "";
  bool _loading = false;
  void register(String name, String email, String pass) async {
    setState(() {
      err = "";
      _loading = true;
    });
    try {
      var url =
          Uri.https('labtim.000webhostapp.com', 'labtim_mob/register.php');
      final response = await http
          .post(url, body: {"name": name, "email": email, "pass": pass});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var result = data['data'];

        int sucess = result[1];
        if (sucess == 1) {
          setState(() {
            err = result[0];
            _loading = false;
          });
        } else {
          setState(() {
            err = result[0];
            _loading = false;
          });
        }
      } else {
        // print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error occurred: $e');
    }
  }

  CustomTextField emailText = CustomTextField(
    title: "Email",
    placeholder: "Enter your email",
    prefixIcon: Icons.email,
  );
  CustomTextField nameText = CustomTextField(
    title: "name",
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
    return _loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Medical App Registre'),
              centerTitle: true,
              actions: [
                PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'Login',
                      child: Text('Login'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'about',
                      child: Text('About'),
                    ),
                  ],
                  onSelected: (value) {
                    _onMenuItemSelected(context, value);
                  },
                ),
              ],
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 80),
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
                                        if (passText.value ==
                                            confirmPassText.value) {
                                          register(nameText.value,
                                              emailText.value, passText.value);
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
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.blue,
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
                                          'Registre',
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

  void _onMenuItemSelected(BuildContext context, String value) {
    switch (value) {
      case 'Login':
        widget.visible.call();
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
