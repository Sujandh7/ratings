import 'package:firebase/provider/passwordvisibility.dart';
import 'package:firebase/util/string_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainUi extends StatelessWidget {
   MainUi({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
      Container(
      color: colorstr,
      ),
      Consumer<Passwordvisibility>(builder: (context, passwordVisibility, child) => 
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.transparent,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:15,right: 15),
              
                    
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                                  
                      ],
                    ),
                  ),
                ),
            
            ],
          ),
        ),
      ),
    ])

    );
  }
}