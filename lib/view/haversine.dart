// import 'dart:math' show atan2, cos, pi, sin, sqrt;
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class PlumberData {
//   static List<double?> latitudeList = [];
//   static List<double?> longitudeList = [];
// }

// class UserData {
//   static double? latitude2;
//   static double? longitude2;
// }

// class FetchPlumberData extends StatefulWidget {
//   @override
//   _FetchPlumberDataState createState() => _FetchPlumberDataState();
// }

// class _FetchPlumberDataState extends State<FetchPlumberData> {
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     await _fetchPlumberLocations();
//     await _fetchUserLocation();
//     _calculateDistance();
//   }

//   Future<void> _fetchPlumberLocations() async {
//     try {
//       QuerySnapshot plumberSnapshot =
//           await FirebaseFirestore.instance.collection('plumber').get();

//       if (plumberSnapshot.docs.isNotEmpty) {
//         for (QueryDocumentSnapshot plumberDocument in plumberSnapshot.docs) {
//           double? latitude = plumberDocument['latitude'];
//           double? longitude = plumberDocument['longitude'];

//           PlumberData.latitudeList.add(latitude);
//           PlumberData.longitudeList.add(longitude);

//           print('Latitude: $latitude');
//           print('Longitude: $longitude');
//         }
//       } else {
//         print('No documents found in the plumber collection.');
//       }
//     } catch (e) {
//       print('Error fetching plumber locations: $e');
//     }
//   }

//   Future<void> _fetchUserLocation() async {
//     try {
//       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//           .collection('userLocations')
//           .doc('x3iquFSG7upBGAT7bjgH')
//           .get();

//       if (userSnapshot.exists) {
//         UserData.latitude2 =
//             double.tryParse(userSnapshot['latitude'].toString());
//         UserData.longitude2 =
//             double.tryParse(userSnapshot['longitude'].toString());

//         print('User Latitude: ${UserData.latitude2}');
//         print('User Longitude: ${UserData.longitude2}');
//       } else {
//         print('No document found in the userLocations collection.');
//       }
//     } catch (e) {
//       print('Error fetching user location: $e');
//     }
//   }

//   double _calculateHaversineDistance(double startLatitude,
//       double startLongitude, double endLatitude, double endLongitude) {
//     const double radius = 6371.0; // Earth's radius in kilometers
//     double dLat = _toRadians(endLatitude - startLatitude);
//     double dLon = _toRadians(endLongitude - startLongitude);

//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_toRadians(startLatitude)) *
//             cos(_toRadians(endLatitude)) *
//             sin(dLon / 2) *
//             sin(dLon / 2);

//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     double distance = radius * c;

//     return distance;
//   }

//   double _toRadians(double degrees) {
//     return degrees * (pi / 180.0);
//   }

//   void _calculateDistance() {
//     if (PlumberData.latitudeList.isNotEmpty &&
//         UserData.latitude2 != null &&
//         UserData.longitude2 != null) {
//       for (int i = 0; i < PlumberData.latitudeList.length; i++) {
//         double? plumberLatitude = PlumberData.latitudeList[i];
//         double? plumberLongitude = PlumberData.longitudeList[i];

//         if (plumberLatitude != null && plumberLongitude != null) {
//           double distance = _calculateHaversineDistance(
//             plumberLatitude,
//             plumberLongitude,
//             UserData.latitude2!,
//             UserData.longitude2!,
//           );

//           print('Distance from plumber $i to user: $distance km');

//           // Update the Firestore document with the calculated distance
//           _updateDistanceInFirestore(i, distance);
//         }
//       }
//     } else {
//       print('No plumber locations available or user location missing.');
//     }
//   }

//   Future<void> _updateDistanceInFirestore(int index, double distance) async {
//     try {
//       // Replace 'plumber' with the actual name of your Firestore collection
//       QuerySnapshot plumberSnapshot =
//           await FirebaseFirestore.instance.collection('plumber').get();

//       if (plumberSnapshot.docs.isNotEmpty) {
//         QueryDocumentSnapshot plumberDocument = plumberSnapshot.docs[index];

//         // Update the 'distance' field in the Firestore document
//         await FirebaseFirestore.instance
//             .collection('plumber')
//             .doc(plumberDocument.id)
//             .update({'distance': distance});

//         print('Distance updated in Firestore for plumber $index: $distance km');
//       } else {
//         print('No documents found in the plumber collection.');
//       }
//     } catch (e) {
//       print('Error updating distance in Firestore: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fetch Plumber Data'),
//       ),
//       body: Center(
//         child: Text('Check the console for plumber and user data.'),
//       ),
//     );
//   }
// }
