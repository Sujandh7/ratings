import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomForm extends StatelessWidget {
  void Function(String)? onChanged;
  TextInputType? keyboardType;
  Widget? prefixIcon;
  Widget? suffixIcon;
  bool obscureText;
  String? hintText;
  String? Function(String?)? validator;
  TextEditingController? controller;

  
  CustomForm({super.key, this.hintText, this.onChanged, this.prefixIcon,this.keyboardType,this.suffixIcon,this.validator,this.obscureText=false,this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ,
      validator: validator,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: prefixIcon,
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
