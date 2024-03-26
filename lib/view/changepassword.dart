import 'package:firebase/util/string_const.dart';
import 'package:firebase/view/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  String? _errorMessage;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      _obscureCurrentPassword = !_obscureCurrentPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      String currentPassword = _currentPasswordController.text.trim();
      String newPassword = _newPasswordController.text.trim();

      try {
        
        AuthCredential credential = EmailAuthProvider.credential(
          email: FirebaseAuth.instance.currentUser!.email!,
          password: currentPassword,
        );
        await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);

        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Password changed successfully.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginUi(),), (route) => false);
                  
                },
                child: Text('OK'),
                
              ),
            ],
          ),
        );

      
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } catch (e) {
        // Handle errors
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: colorstr,
        title: Text('Change Password',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrentPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    labelText: 'Current Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureCurrentPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: _toggleCurrentPasswordVisibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNewPassword ? Icons.visibility_off: Icons.visibility),
                      onPressed: _toggleNewPasswordVisibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    } else if (!passwordRegex.hasMatch(value)) {
                      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                    labelText: 'Confirm New Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,),
                      onPressed: _toggleConfirmPasswordVisibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    } else if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.height*0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: colorstr,onPrimary: Colors.white),
                    onPressed: _changePassword,
                    child: Text('Change Password'),
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
