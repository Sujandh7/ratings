// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/view/profile.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// import 'login.dart';

// class EditProfilePage extends StatefulWidget {
//   final User? user;
//     final Map<String, dynamic>? userData;


//   EditProfilePage({required this.user,this.userData});

//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final _formKey = GlobalKey<FormState>();

//   String? _name;
//   String? _email;
//   String? _contact;
//   String? _address;
//   File? _imageFile;
  
//   final CollectionReference _usersCollection =
//       FirebaseFirestore.instance.collection('users');

//   @override
//   void initState() {
//     super.initState();
//     _name = widget.user?.displayName;
//     _email = widget.user?.email;
//     _contact = widget.user?.phoneNumber;
//     // Initialize _address to the current user's address if available
//     // Otherwise, set it to an empty string
//     _address = ""; // Replace this with logic to fetch user's address from Firestore
//   }

//   Future<void> _updateProfile() async {
//    final User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         await user.updateProfile(displayName: _name);

//         if (_email != null) {
//           await user.updateEmail(_email!);
//         }

//         await _usersCollection.doc(user.uid).update({
//           'name': _name,
//           'email': _email,
//           'contact': _contact,
//           'address': _address,
//         });

//         // Update other user data in Firestore if needed
//         // await _updateUserData(user.uid, {...});

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile updated successfully')),
//         );
//           Navigator.pop(
//           context,
//           MaterialPageRoute(builder: (context) => ProfilePage()), // Pass user here
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error updating profile: $e')),
//         );
//       }
//     }
//   }

//   Future<String?> _uploadImageToStorage(File file) async {
//     try {
//       firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//           .ref()
//           .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
//       firebase_storage.UploadTask uploadTask = ref.putFile(file);
//       firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
//       return await taskSnapshot.ref.getDownloadURL();
//     } catch (e) {
//       print('Error uploading image to Firebase Storage: $e');
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                  backgroundImage: _imageFile != null
//     ? FileImage(_imageFile!) as ImageProvider<Object>
//     : (widget.user?.photoURL != null
//         ? NetworkImage(widget.user!.photoURL!) as ImageProvider<Object>
//         : AssetImage('path_to_placeholder_image') as ImageProvider<Object>), // Provide a placeholder image asset path
//  // Provide a placeholder image asset path

//                   radius: 75,
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   initialValue: _name,
//                   onChanged: (value) {
//                     setState(() {
//                       _name = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Name',
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   initialValue: _email,
//                   onChanged: (value) {
//                     setState(() {
//                       _email = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   initialValue: _contact,
//                   onChanged: (value) {
//                     setState(() {
//                       _contact = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Contact',
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   initialValue: _address,
//                   onChanged: (value) {
//                     setState(() {
//                       _address = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Address',
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     // Open image picker to choose an image from gallery
//                     final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

//                     if (pickedFile != null) {
//                       setState(() {
//                         _imageFile = File(pickedFile.path);
//                       });

//                       // Upload the image to Firebase Storage and get the download URL
//                       String? imageURL = await _uploadImageToStorage(_imageFile!);

//                       if (imageURL != null) {
//                         // Update the user's profile with the new photo URL
//                         await FirebaseAuth.instance.currentUser?.updateProfile(photoURL: imageURL);
//                       }
//                     } else {
//                       print('No image selected.');
//                     }
//                   },
//                   child: Text('Choose Image'),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       _updateProfile();
//                     }
//                   },
//                   child: Text('Update Profile'),
//                 ),
//                 ElevatedButton(
//   onPressed: () async {
//     _deleteProfile();
//   },
//   style: ElevatedButton.styleFrom(
//     primary: Colors.red,
//   ),
//   child: Text('Delete Profile'),
// ),

//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   Future<void> _deleteProfile() async {
//   final User? user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     try {
//       // Delete user data from Firestore
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      
//       // Delete user from Firebase Auth
//       await user.delete();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Profile deleted successfully')),
//       );

//       // Navigate to login screen after deleting profile
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginUi()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error deleting profile: $e')),
//       );
//     }
//   }
// }

// }
