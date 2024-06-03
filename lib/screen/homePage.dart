import 'package:flutter/material.dart';
import 'package:labtim_mobile/model/userModel/userModel.dart';
import 'package:labtim_mobile/screen/auttentification/login.dart';
import 'package:labtim_mobile/screen/auttentification/registre.dart';
import 'package:labtim_mobile/screen/home/home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  bool visible = true, login = false;
  isconnected() async {
    await UserModel.getUser();
    if (UserModel.sessionUser == null) {
      setState(() {
        login = false;
      });
    } else {
      setState(() {
        login = true;
      });
    }
  }

  toggle() {
    setState(() {
      visible = !visible;
    });
  }

  islogin() {
    setState(() {
      login = !login;
    });
  }

  @override
  void initState() {
    super.initState();
    isconnected();
  }

  @override
  Widget build(BuildContext context) {
    return login
        ? Home(
            login: islogin,
          )
        : visible
            ? Login(toggle, islogin)
            : Registre(toggle);
  }
}
