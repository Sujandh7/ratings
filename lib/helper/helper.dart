import 'dart:ui';
import 'package:firebase/util/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Helper {
  static backdropFilter(context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3),
      child: SafeArea(
          child: Stack(
        children: [
          const Center(
            child: SpinKitCircle(
              color: const Color.fromARGB(255, 10, 135, 14),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0),
          ),
        ],
      )),
    );
  }
  static snackBarMessage(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
