import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/userlocation.dart';

class LocationPage extends StatefulWidget {

  @override
  _LocationPageState createState() => _LocationPageState();

  // Getter methods to access latitude and longitude
  double? get latitude => _LocationPageState._latitude;
  double? get longitude => _LocationPageState._longitude;
}

class _LocationPageState extends State<LocationPage> {
  static double? _latitude;
  static double? _longitude;
  String? _locationName;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print("Location permission denied by user.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      print("Current Position: $position");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationName = placemarks.isNotEmpty ? placemarks[0].name : "Location Name Not Available";
      });

      // Push latitude and longitude to Firestore
      _pushLocationToFirestore();
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> _pushLocationToFirestore() async {
    try {
      Userlocation userLocation = Userlocation(latitude: _latitude.toString(), longitude: _longitude.toString());

      // Check if document already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("userLocations")
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the existing document
        await querySnapshot.docs.first.reference.update(userLocation.toJson());
      } else {
        // Document doesn't exist, add a new one
        await FirebaseFirestore.instance.collection("userLocations").add(
          userLocation.toJson(),
        );
      }

      print('Location pushed to Firestore: Latitude $_latitude, Longitude $_longitude');
    } catch (e) {
      print('Error pushing location to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Demo'),
      ),
      body: Center(
        child: _latitude != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Latitude: $_latitude'),
                  Text('Longitude: $_longitude'),
                  SizedBox(height: 16),
                  Text(
                    'Current Location Name:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('$_locationName'),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
