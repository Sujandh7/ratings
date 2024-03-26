import 'package:firebase/custom_ui/customelevatedbutton.dart';
import 'package:firebase/custom_ui/customform.dart';
import 'package:firebase/provider/passwordvisibility.dart';
import 'package:firebase/util/string_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Otp extends StatelessWidget {
   Otp({super.key});
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
                height: MediaQuery.of(context).size.height * 0.4,
                color: Colors.transparent,
              ),
              Container(
                
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                  color: Colors.white,
                ),
                
                child: Padding(
                  padding: const EdgeInsets.only(top:12.0),
                  child: Column(
                    children: [
                  
                      Text("Verification",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                      Text("Enter your OTP code number",style: TextStyle(fontSize: 19)),
                      SizedBox(height: height(0.01, context),),
                
                      Container(
                        width:width(0.93, context) ,
                        height: height(0.23, context),
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Colors.lightGreen[200]),
                      child: Column(
                        children: [
                          Row(
                            children: [
                SizedBox(height: height(0.15, context),),
                TextField()
                            ],
                          ),
                          SizedBox(
                            width: width(0.7, context),
                            child: CustomElevatedButton(onPressed: () {
                              
                            },
                            child: Text("Verify"),primary: colorstr,onprimary: Colors.white,),
                          )
                        ],
                      ),
                      
                      ),
                      SizedBox(height: height(0.02, context),),
                      Text("Didn't you receive any code?",style: TextStyle(fontSize: 20)),
                      Text("Resend New Code",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,decoration: TextDecoration.underline))
                
                
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ])

    );
  }
  height(value, context) {
    return MediaQuery.of(context).size.height * value;
  }

  width(value, context) {
    return MediaQuery.of(context).size.width * value;
  }

}