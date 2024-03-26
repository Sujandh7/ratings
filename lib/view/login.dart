import 'package:firebase/api/api_service_impl.dart';
import 'package:firebase/api/apiservice.dart';
import 'package:firebase/api/status_util.dart';
import 'package:firebase/custom_ui/customelevatedbutton.dart';
import 'package:firebase/custom_ui/customform.dart';
import 'package:firebase/helper/helper.dart';
import 'package:firebase/provider/passwordvisibility.dart';
import 'package:firebase/util/string_const.dart';
import 'package:firebase/view/dashboard.dart';
import 'package:firebase/view/forgetpassword.dart';
import 'package:firebase/view/navbar.dart';
import 'package:firebase/view/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../api/auth_service.dart';

class LoginUi extends StatefulWidget {
   
  LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();

}

class _LoginUiState extends State<LoginUi> {
  final RegExp emailRegex =
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        final RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  ApiService apiService = ApiServiceImpl();
  AuthService authService=AuthService();
  final _formKey = GlobalKey<FormState>();
      final AuthService _authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<Passwordvisibility>(
      builder: (context, passwordVisibility, child) => Stack(children: [
        Container(
          color: colorstr,
        ),
        SingleChildScrollView(child: loginUi(context, passwordVisibility)),
      ]),
    ));
  }

  Widget loginUi(BuildContext context, Passwordvisibility passwordVisibility) {
    //function
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          color: Colors.transparent,
          child: Image(image: AssetImage("asset/images/logo.png")),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.52,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(40), topLeft: Radius.circular(40)),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loginnowStr,
                        style: TextStyle(
                            color: colorstr,
                            fontSize: 19,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text(
                          userStr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        ClipRRect(
                          child: SizedBox(
                            height: 31,
                            child: TextButton(
                              onPressed: () {
                                //print("button pressed");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentForm()));
                              },
                              child: Text(
                                accountStr,
                                style: TextStyle(color: colorstr),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    CustomForm(
                      hintText: EmailaddressStr,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email,
                        color: colorstr,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return emailValidationStr;
                        }
                         else if(!emailRegex.hasMatch(value)){
                              return 'Please enter a valid email';

                         }
                    
                          return null;
                        
                      },
                      onChanged: (value) {
                        passwordVisibility.email = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomForm(
                      obscureText:
                  passwordVisibility.showPassword  ? false : true,
              suffixIcon: passwordVisibility.showPassword 
                  ? IconButton(
                      onPressed: () {
                        passwordVisibility.Visibility(false);
                        
                      },
                      icon: const Icon(Icons.visibility))
                  : IconButton(
                      onPressed: () {
                        passwordVisibility.Visibility(true);
                      },
                      icon: const Icon(Icons.visibility_off)),
                      hintText: passwordStr,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: colorstr,
                      ),
                      
                      validator: (value) {
                        if (value!.isEmpty) {
                          return passwordValidationStr;
                        } else if(!passwordRegex.hasMatch(value)) {
                              return 'Must have 8 char(include uppercase,lowercase & number)';

                        }
                        return null;
                      },
                      
                      onChanged: (value) {
                        passwordVisibility.password = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 65,
                      child: CustomElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            User? user = await _authService.signInWithEmailAndPassword(
                              passwordVisibility.email!,
                              passwordVisibility.password!,
                            );
                            if (user != null) {
                              Helper.snackBarMessage("Successfully Logged in", context);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => Navbar()),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              Helper.snackBarMessage("Invalid Credential!!!", context);
                            }
                          }
                        },
                        child: Text(loginStr),
                        primary: colorstr,
                        onprimary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                    ,
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              //  print("forget password button is pressed");
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage(),));

                            },
                            child: Text(
                              ForgetpassStr,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            )),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              //  print("Signup password button is pressed");
                                Navigator.push(context, MaterialPageRoute(builder: (context) => StudentForm(),));

                            },
                            child: Text(SignupStr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline)))
                      ],
                    ),
                 
                 Row(
                   children: [
                      ElevatedButton(
            onPressed: () {
              googleLogin(context);

            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.google),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Login with Google")
                ],
              ),
            ))
                     
                   ],
                 )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
   googleLogin(BuildContext context)async{
        String? token;

   FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        print(user!.phoneNumber);
        // var token= await user.getIdToken();
        // print(token);
        //ya mathi ko 2 line ra tal ko same ho
        await user.getIdToken().then((value) { //aaba value ma Idtoken basxa 
          token=value;
          print(token);
        },);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {

        // handle the error here
      }
      if(token!=null){//not equal 
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Navbar()), 
        (route) => false);
      }
    }}

}
