// import 'package:firebase/util/string_const.dart';
// import 'package:firebase/view/plumber.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'PlumberDetailsCard.dart';

// class PhotographerDetails extends StatefulWidget {
//   @override
//   _PhotographerDetailsState createState() => _PhotographerDetailsState();
// }
// class _PhotographerDetailsState extends State<PhotographerDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: colorstr,
//         foregroundColor: Colors.white,
//         title: Text("Photographer Details", ),
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
             
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance.collection("plumber").snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }

//                     if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     }

//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return Center(child: Text('No plumber details found in Firestore.'));
//                     }

//                     // Create a list to store carpenter details
//                     List<PlumberDetails> PhotographerDetailsList = [];

//                     // Iterate through the documents and add carpenter details to the list
//                     snapshot.data!.docs.forEach((doc) {
//                       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//                       PlumberDetails plumberDetails = PlumberDetails.fromMap(data);

//                       // Check if the profession is "carpenter"
//                       if (plumberDetails.profession.toLowerCase() == "photographer") {
//                         PhotographerDetailsList.add(plumberDetails);
//                       }
//                     });

//                     // Sort carpenter details by distance (smallest distance first)
//                     PhotographerDetailsList.sort((a, b) => a.distance.compareTo(b.distance));

//                     return ListView.builder(
//                       itemCount: PhotographerDetailsList.length,
//                       itemBuilder: (context, index) {
//                         PlumberDetails plumberDetails = PhotographerDetailsList[index];
//                         return PlumberDetailsCard(plumberDetails);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   } 
// }

