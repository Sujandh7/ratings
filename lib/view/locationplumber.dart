import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlumberLocationDetails extends StatefulWidget {
  @override
  _PlumberLocationDetailsState createState() => _PlumberLocationDetailsState();
}

class _PlumberLocationDetailsState extends State<PlumberLocationDetails> {
  @override
  void initState() {
    super.initState();
    fetchPlumberLocations();
  }

  Future<void> fetchPlumberLocations() async {
    try {
      // Fetch documents from the "plumber" collection
      QuerySnapshot plumberSnapshot = await FirebaseFirestore.instance.collection("plumber").get();

      // Iterate through each document
      for (QueryDocumentSnapshot plumberDocument in plumberSnapshot.docs) {
        // Get the location name from the document
        String locationName = plumberDocument['location'];

        // Append ", Nepal" to the location name
        String locationNameNepal = '$locationName, Nepal';

        // Add "Cooma, Nepal" to the location name
        String locationNameCoomaNepal = '$locationNameNepal';

        // Find the longitude and latitude for the modified location name
        List<Location> locations = await locationFromAddress(locationNameCoomaNepal);

        if (locations.isNotEmpty) {
          double latitude = locations.first.latitude;
          double longitude = locations.first.longitude;

          // Update the Firestore document with latitude and longitude
          await FirebaseFirestore.instance.collection("plumber").doc(plumberDocument.id).update({
            'latitude': latitude,
            'longitude': longitude,
          });

          print('Location: $locationNameCoomaNepal');
          print('Latitude: $latitude');
          print('Longitude: $longitude');
        } else {
          print('Location not found: $locationNameCoomaNepal');
        }
      }
    } catch (e) {
      print('Error fetching plumber locations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plumber Location Details'),
      ),
      body: Center(
        child: Text('Check the console for location details.'),
      ),
    );
  }
}
