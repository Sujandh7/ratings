import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../util/string_const.dart';
import 'login.dart';

class EditProfilePage extends StatefulWidget {
  final User? user;
    final Map<String, dynamic>? userData;


  EditProfilePage({required this.user,this.userData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();


  String? _name;
  String? _email;
  String? _contact;
  String? _address;
  File? _imageFile;
  
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _name = widget.user?.displayName;
     _email = widget.user?.email;
     _contact = widget.user?.phoneNumber;
     _address = ""; 
  }
  Future<void> _loadUserData() async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user!.uid)
            .get();

    // Extract user data from the snapshot and assign them to variables
    if (snapshot.exists) {
      setState(() {
        _name = snapshot.data()?['name'];
        _email = snapshot.data()?['email'];
        _contact = snapshot.data()?['contact'];
        _address = snapshot.data()?['address'] ?? ''; // Use default value if address is null
      });
    } else {
      print('User data not found');
    }
  } catch (e) {
    print('Error loading user data: $e');
  }
}

  Future<void> _updateProfile() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // Upload the image to Firebase Storage if a new image is selected
      String? imageURL;
      if (_imageFile != null) {
        imageURL = await _uploadImageToStorage(_imageFile!);
      }

      // Update user profile details
      await user.updateProfile(
        displayName: _name,
        photoURL: imageURL != null ? imageURL : user.photoURL,
      );

      // Update user's email if it's changed
      if (_email != null && _email != user.email) {
        await user.updateEmail(_email!);
      }

      // Update user data in Firestore
      await _usersCollection.doc(user.uid).update({
        'name': _name,
        'email': _email,
        'contact': _contact,
        'address': _address,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }
}

  Future<String?> _uploadImageToStorage(File file) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
      firebase_storage.UploadTask uploadTask = ref.putFile(file);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: colorstr,
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
  children: [
    Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: colorstr,width: 3),
        shape: BoxShape.circle
      ),
             child: CircleAvatar(
        
        backgroundImage: _imageFile != null
            ? FileImage(_imageFile!)
            : (widget.user?.photoURL != null
                ? NetworkImage(widget.user!.photoURL!) as ImageProvider<Object>
                : NetworkImage('https://icons.veryicon.com/png/o/miscellaneous/wizhion/person-20.png')),
        radius: 75,
        backgroundColor: Colors.grey[200], // Add background color for border
      ),
    ),
    Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green[50],
        ),
        child: IconButton(
          icon: Icon(Icons.camera_alt),
          focusColor: Colors.purple,hoverColor: colorstr,highlightColor: Colors.purple,
          color: colorstr,
          onPressed: () 
            async {
                    // Open image picker to choose an image from gallery
                    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      setState(() {
                        _imageFile = File(pickedFile.path);
                      });

                      // Upload the image to Firebase Storage and get the download URL
                      String? imageURL = await _uploadImageToStorage(_imageFile!);

                      if (imageURL != null) {
                        // Update the user's profile with the new photo URL
                        await FirebaseAuth.instance.currentUser?.updateProfile(photoURL: imageURL);
                      }
                    } else {
                      print('No image selected.');
                    }
                  },

          
        ),
      ),
    ),
  ],
),

                SizedBox(height: 20),
                TextFormField(
              
                  initialValue: _name,
                  validator:(value) {
                     if (value == null || value.isEmpty) {
      return "${nameValidationStr}";
    }
    if (value.isNotEmpty &&
        !RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Name should be a string';
    }
    return null;
  
                  }, 
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _email,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),

                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _contact,
                   validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Contact number is required';
    }
    if (!RegExp(r'^98\d{8}$').hasMatch(value)) {
      return 'Contact number is not correct';
    }
    return null;
  },
                  onChanged: (value) {
                    setState(() {
                      _contact = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),

                    labelText: 'Contact',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _address,
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),

                    labelText: 'Address',
                  ),
                ),
                SizedBox(height: 20),
             Row(
             children: [
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(primary: colorstr,onPrimary: Colors.white),
                //   onPressed: () async {
                //     // Open image picker to choose an image from gallery
                //     final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

                //     if (pickedFile != null) {
                //       setState(() {
                //         _imageFile = File(pickedFile.path);
                //       });

                //       // Upload the image to Firebase Storage and get the download URL
                //       String? imageURL = await _uploadImageToStorage(_imageFile!);

                //       if (imageURL != null) {
                //         // Update the user's profile with the new photo URL
                //         await FirebaseAuth.instance.currentUser?.updateProfile(photoURL: imageURL);
                //       }
                //     } else {
                //       print('No image selected.');
                //     }
                //   },
                //   child: Text('Choose Image'),
                // ),
                
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: colorstr,onPrimary: Colors.white),

                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateProfile();
                    }
                  },
                  child: Text('Update Profile'),
                ),
             ]
             )
//                 ElevatedButton(
//   onPressed: () async {
//     deleteProfile();
//   },
//   style: ElevatedButton.styleFrom(
//     primary: Colors.red,
//   ),
//   child: Text('Delete Profile'),
// ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> deleteProfile() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // Prompt the user to reauthenticate before deleting the profile
      // You can use various reauthentication methods such as email/password, phone number, etc.
      // Here, we use email/password reauthentication for demonstration purposes
     // AuthCredential credential = EmailAuthProvider.credential(); // Replace 'password' with the user's password

      // Reauthenticate user with the provided credential
    //  await user.reauthenticateWithCredential(credential);

      // Once reauthentication is successful, proceed with profile deletion

      // Delete user data from Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      
      // Delete user from Firebase Auth
      await user.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile deleted successfully')),
      );

      // Navigate to login screen after deleting profile
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginUi(),), (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting profile: $e')),
      );
    }
  }
}

}