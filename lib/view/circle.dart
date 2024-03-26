import 'package:flutter/material.dart';

class CircleA extends StatelessWidget {
  const CircleA({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('Circle Avatar with Camera Icon'),
        ),
        body: Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}