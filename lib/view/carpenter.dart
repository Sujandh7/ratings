

// import 'package:firebase/util/string_const.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CarpenterDetails {
//   final String name;
//   final String location;
//   final int rating;
//   final int contact;

//   CarpenterDetails({
//     required this.name,
//     required this.location,
//     required this.rating,
//     required this.contact,
//   });

//   factory CarpenterDetails.fromMap(Map<String, dynamic> map) {
//     try {
//       return CarpenterDetails(
//         name: map['name'] ?? '',
//         location: map['location'] ?? '',
//         rating: (map['rating'])  ?? 5,
//         contact: map['contact'] ?? '',
//       );
//     } catch (e) {
//       print('Error creating CarpenterDetails: $e');
//       throw e;
//     }
//   }
// }


// class StarRating extends StatelessWidget {
//   final int starCount;
//   final int rating;

//   StarRating({required this.starCount, required this.rating});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children:
      
//        List.generate(
//         starCount,
//         (index) {
//           return Icon(
//             index < rating ? Icons.star : Icons.star_border,
//             color: colorstr,
//           );
//         },
//       ),
//     );
//   }
// }

// class CarpenterDetailsCard extends StatelessWidget {
//   final CarpenterDetails carpenterDetails;

//   CarpenterDetailsCard(this.carpenterDetails);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // When the card is tapped, show complete details in a dialog
//         _showDetailsDialog(context, carpenterDetails);
//       },
//       child: Card(
//         margin: EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               title: Text(carpenterDetails.name),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Location: ${carpenterDetails.location}'),
//                   Text("Rating:"),
//                   StarRating(
//                     starCount: 5, // You can adjust the number of stars
//                     rating: carpenterDetails.rating.toInt(),
//                   ),
//                   Text('Contact: ${carpenterDetails.contact}'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Function to show details in a dialog
//   void _showDetailsDialog(BuildContext context, CarpenterDetails details) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Complete Details'),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Name: ${details.name}'),
//               Text('Location: ${details.location}'),
//                   Text("Rating:"),
//               StarRating(
//                 starCount: 5,
//                 rating: details.rating.toInt(),
//               ),
//               Text('Contact: ${details.contact}'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


// class CarpenterDetailsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar( 
//         backgroundColor: colorstr,
//         title: Text('Carpenter Details'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection("carpenter").snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No carpenter details found in Firestore.'));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               try {
//                 Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
//                 print("Data for index $index: $data");
//                 CarpenterDetails plumberDetails = CarpenterDetails.fromMap(data);
//                 return CarpenterDetailsCard(plumberDetails);
//               } catch (e) {
//                 print("Error processing data for index $index: $e");
//                 return Container(); // Skip invalid data
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: Text('Plumber Details'),
// //         ),
// //         body: Center(
// //           child: ElevatedButton(
// //             onPressed: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => PlumberDetailsPage()),
// //               );
// //             },
// //             child: Text('Show Plumber Details'),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
