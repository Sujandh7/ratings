import 'package:firebase/util/string_const.dart';
import 'package:firebase/view/login.dart';
import 'package:firebase/view/navbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    navigateToAnotherPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: colorstr,
            child: Center(
                child: Image.asset(
              "asset/images/logo.png",
              height: 160,
              width: 160,
            )),
          )
        ],
      ),
    );
  }

  navigateToAnotherPage() async {
   // final prefs = await SharedPreferences.getInstance();
    //final bool isUserExist = prefs.getBool('isUserExist') ?? false;
    Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
              // !isUserExist
                  LoginUi()
                //  Navbar(

                //     )
                    ),
          (Route<dynamic> route) => false);
    });
  }
}