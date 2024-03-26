import 'package:flutter/material.dart';

class WillPopScopes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? exit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit App?'),
              content: Text('Are you sure you want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Close the dialog and return false
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Close the dialog and return true
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );
        
        // Return false if showDialog returns null or if exit is null
        return exit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Back Button Confirmation'),
        ),
        body: Center(
          child: Text('Press the back button to test'),
        ),
      ),
    );
  }
}
