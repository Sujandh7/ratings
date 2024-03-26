import 'package:firebase/util/string_const.dart';
import 'package:firebase/view/ServiceProviderRegestration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'editprofile.dart'; // Import your EditProfilePage

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        if (user.providerData.isNotEmpty &&
            user.providerData[0].providerId == 'google.com') {
          // If the user signed in with Google, use Google provider data
          userData = {
            'name': user.displayName ?? 'N/A',
            'email': user.email ?? 'N/A',
            'contact': 'N/A', // Add Google-specific data as needed
            'address': 'N/A', // Add Google-specific data as needed
            'photoUrl': user.photoURL ??
                '', // Set photoUrl for both Google and email/password login
          };
        } else {
          // If the user signed in with email/password, fetch data from Firestore
          DocumentSnapshot<Map<String, dynamic>> snapshot =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

          if (snapshot.exists) {
            userData = snapshot.data();
            // Ensure that the 'photoUrl' field is set, even if it's empty
            userData!['photoUrl'] ??= '';
          }
        }

        setState(() {});
      } catch (error) {
        print('Error fetching user profile data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Profile",
        ),
        backgroundColor: colorstr,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Center(
  child: Stack(
    children: [
                      if(user!=null)

      Container(
            padding: EdgeInsets.all(5.0), // 

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorstr,
            width: 3.0,

          ),
          
        
        ),
        child:
        
         CircleAvatar(
          
          backgroundImage: user.photoURL != null &&
                  user.photoURL!.isNotEmpty
              ? NetworkImage(user.photoURL!)
              : NetworkImage(
                  'https://icons.veryicon.com/png/o/miscellaneous/wizhion/person-20.png'), // Provide a placeholder image URL
          radius: 75,
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
           decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:  Colors.green[50],
        ),
          child: IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditProfilePage(user: user, userData: userData),
                ),
              ).then((_) {
                // Update user data after returning from the EditProfilePage
                fetchUserData();
              });
            },
            icon: Icon(FontAwesomeIcons.solidEdit,),focusColor: Colors.purple,hoverColor: colorstr,highlightColor: Colors.purple,
            color: colorstr,
            // Adjust the size of the icon as needed
            iconSize: 20,
          ),
        ),
      ),
    ],
  ),
),

            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                  child: Text("Profile Details", style: TextStyle(fontSize: 30))),
            ),
            SizedBox(height: 20),
            buildProfileField("Name:", userData?['name'] ?? 'N/A'),
            buildProfileField("Email:", userData?['email'] ?? 'N/A'),
            buildProfileField("Contact:", userData?['contact'] ?? 'N/A'),
            buildProfileField("Address:", userData?['address'] ?? 'N/A'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.07,),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //       primary: colorstr, onPrimary: Colors.white),
                  //   onPressed: () async {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //             EditProfilePage(user: user, userData: userData),
                  //       ),
                  //     ).then((_) {
                  //       // Update user data after returning from the EditProfilePage
                  //       fetchUserData();
                  //     });
                  //   },
                    
                  //  child: Text('Edit Profile'),
                  // ),
                  SizedBox(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: colorstr, onPrimary: Colors.white),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceProviderRegistration(),
                          )),
                      child: Text(
                        "Register as service provider",
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(value, style: TextStyle(fontSize: 20)),
            ),
            foregroundDecoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.055,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1),
              color: Colors.green[50],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
