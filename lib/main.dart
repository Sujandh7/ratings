import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/provider/passwordvisibility.dart';
import 'package:firebase/util/Firestoreutils.dart';
import 'package:firebase/util/string_const.dart';
import 'package:firebase/view/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'model/userlocation.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 // FirestoreUtils.updatePlumberRating();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
   MyApp({super.key});
  FirebaseMessaging messaging = FirebaseMessaging.instance;


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static double? _latitude;
  static double? _longitude;
String? _locationName;
static List<double?> plumberLatitudeList = [];
  static List<double?> plumberLongitudeList = [];
  static double? userLatitude;
  static double? userLongitude;

  void initState(){
    requestLocationPermission();
    notificationSetting();
    listenNotification();
    fetchPlumberLocations();
    _getCurrentLocation();
    _fetchData();
    
    
    super.initState();

  //  readValueFromSharedPreference();
  }
  bool isUserExist=false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
ChangeNotifierProvider<Passwordvisibility>(create: (context) => Passwordvisibility(),),

      ],
      child:  MaterialApp( debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
          
            colorScheme: ColorScheme.fromSeed(seedColor:colorstr),
            useMaterial3: true,
          ),
          home:
        SplashScreen()
          // WillPopScopes()
              //isUserExist? Dashboard():LoginUi(),
      // SettingsPage()
        ),
      
    );
  }

  readValueFromSharedPreference()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
isUserExist = prefs.getBool('isUserExit')??false ; //yedi user exit ko value kayhee aayena vane bu default false nai hunxa ?? ko kam tei ho
setState(() {
});
isUserExist; // isUserExist ko value change vairako ko kura lai UI ma update garaune 
  }
  notificationSetting()async{

NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,
);

print('User granted permission: ${settings.authorizationStatus}');
  }
  listenNotification(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
print(message);
    });

  }
  getToken()async{
    String? token = await messaging.getToken();//yo device ko token yeslai init state ma call garne
  }
  void requestLocationPermission() async {
    // Check if location permission is granted
    var status = await Permission.location.status;
    if (status.isDenied) {
      // If location permission is not granted, request it
      await Permission.location.request();
    }
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
   Future<void> _fetchData() async {
    await _fetchPlumberLocations();
    await _fetchUserLocation();
    _calculateDistance();
calculatevicentyDistance();
  }

  Future<void> _fetchPlumberLocations() async {
    try {
      QuerySnapshot plumberSnapshot =
          await FirebaseFirestore.instance.collection('plumber').get();

      if (plumberSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot plumberDocument in plumberSnapshot.docs) {
          double? latitude = plumberDocument['latitude'];
          double? longitude = plumberDocument['longitude'];

          plumberLatitudeList.add(latitude);
          plumberLongitudeList.add(longitude);

          print('Plumber Latitude: $latitude');
          print('Plumber Longitude: $longitude');
        }
      } else {
        print('No documents found in the plumber collection.');
      }
    } catch (e) {
      print('Error fetching plumber locations: $e');
    }
  }

  Future<void> _fetchUserLocation() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('userLocations')
          .doc('x3iquFSG7upBGAT7bjgH')
          .get();

      if (userSnapshot.exists) {
        userLatitude = double.tryParse(userSnapshot['latitude'].toString());
        userLongitude = double.tryParse(userSnapshot['longitude'].toString());

        print('User Latitude: $userLatitude');
        print('User Longitude: $userLongitude');
      } else {
        print('No document found in the userLocations collection.');
      }
    } catch (e) {
      print('Error fetching user location: $e');
    }
  }
  double _calculateHaversineDistance(double startLatitude,
      double startLongitude, double endLatitude, double endLongitude) {
    const double radius = 6371.0; // Earth's radius in kilometers
    double dLat = _toRadians(endLatitude - startLatitude);
    double dLon = _toRadians(endLongitude - startLongitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(startLatitude)) *
            cos(_toRadians(endLatitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radius * c;

    return distance;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  void _calculateDistance() {
    if (plumberLatitudeList.isNotEmpty &&
        userLatitude != null &&
        userLongitude != null) {
      for (int i = 0; i < plumberLatitudeList.length; i++) {
        double? plumberLatitude = plumberLatitudeList[i];
        double? plumberLongitude = plumberLongitudeList[i];

        if (plumberLatitude != null && plumberLongitude != null) {
          double distance = _calculateHaversineDistance(
            plumberLatitude,
            plumberLongitude,
            userLatitude!,
            userLongitude!,
          );

          print('HaversignDistance from plumber $i to user: $distance km');

          // Update the Firestore document with the calculated distance
        //  _updateDistanceInFirestore(i, distance);
        }
      }
    } else {
      print('No plumber locations available or user location missing.');
    }
  }

  Future<void> _updateDistanceInFirestore(int index, double distance) async {
    try {
      QuerySnapshot plumberSnapshot =
          await FirebaseFirestore.instance.collection('plumber').get();

      if (plumberSnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot plumberDocument = plumberSnapshot.docs[index];

        await FirebaseFirestore.instance
            .collection('plumber')
            .doc(plumberDocument.id)
            .update({'distance': distance});

        print('Distance updated in Firestore for plumber $index: $distance km');
      } else {
        print('No documents found in the plumber collection.');
      }
    } catch (e) {
      print('Error updating distance in Firestore: $e');
    }
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

      
        String locationNameCoomaNepal = '$locationNameNepal';

      
        List<Location> locations = await locationFromAddress(locationNameCoomaNepal);

        if (locations.isNotEmpty) {
          double latitude = locations.first.latitude;
          double longitude = locations.first.longitude;

        
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


  
  double greatCircleDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in kilometers

    // Convert latitude and longitude from degrees to radians
    double lat1Rad = _toRadians(lat1);
    double lon1Rad = _toRadians(lon1);
    double lat2Rad = _toRadians(lat2);
    double lon2Rad = _toRadians(lon2);

    // Calculate the difference between latitudes and longitudes
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    // Calculate the distance using the Great Circle Distance formula
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c;

    return distance;
  }
 double toRadians(double degree) {
    return degree * pi / 180;
  }
  void calculategreatcircleDistance() {
    if (plumberLatitudeList.isNotEmpty &&
        userLatitude != null &&
        userLongitude != null) {
      for (int i = 0; i < plumberLatitudeList.length; i++) {
        double? plumberLatitude = plumberLatitudeList[i];
        double? plumberLongitude = plumberLongitudeList[i];

        if (plumberLatitude != null && plumberLongitude != null) {
          double distance = greatCircleDistance(
            plumberLatitude,
            plumberLongitude,
            userLatitude!,
            userLongitude!,
          );

          print('GreatCircleDistance from plumber $i to user: $distance km');

          // Update the Firestore document with the calculated distance
       //   _updateDistanceInFirestore(i, distance);
        }
      }
    } else {
      print('No plumber locations available or user location missing.');
    }
  }



   static double getVincentyDistance(
      double lat1, double lon1, double lat2, double lon2) {
    double a = 6378137, b = 6356752.314245, f = 1 / 298.257223563;

    double degToRad(double degree) {
      return degree * (pi / 180.0);
    }

    double L = degToRad(lon2 - lon1);

    double U1 = atan((1 - f) * tan(degToRad(lat1)));

    double U2 = atan((1 - f) * tan(degToRad(lat2)));

    double sinU1 = sin(U1), cosU1 = cos(U1);

    double sinU2 = sin(U2), cosU2 = cos(U2);

    double cosSqAlpha, sinSigma, cos2SigmaM, cosSigma, sigma;

    double lambda = L, lambdaP, iterLimit = 100;

    do {
      double sinLambda = sin(lambda), cosLambda = cos(lambda);

      sinSigma = sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) +
          (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) *
              (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));

      if (sinSigma == 0) return 0;

      cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;

      sigma = atan2(sinSigma, cosSigma);

      double sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;

      cosSqAlpha = 1 - sinAlpha * sinAlpha;

      cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;

      double C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));

      lambdaP = lambda;

      lambda = L +
          (1 - C) *
              f *
              sinAlpha *
              (sigma +
                  C *
                      sinSigma *
                      (cos2SigmaM +
                          C *
                              cosSigma *
                              (-1 +
                                  2 * cos2SigmaM * cos2SigmaM)));
    } while ((lambda - lambdaP).abs() > 1e-12 && --iterLimit > 0);

    if (iterLimit == 0) return 0;

    double uSq = cosSqAlpha * (a * a - b * b) / (b * b);

    double A = 1 +
        uSq / 16384 *
            (4096 +
                uSq * (-768 + uSq * (320 - 175 * uSq)));

    double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));

    double deltaSigma = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma *
        (-1 + 2 * cos2SigmaM * cos2SigmaM) -
        B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) *
            (-3 + 4 * cos2SigmaM * cos2SigmaM)));

    double s = (b * A * (sigma - deltaSigma))/1000;
    return s;
  }
   void calculatevicentyDistance() {
    if (plumberLatitudeList.isNotEmpty &&
        userLatitude != null &&
        userLongitude != null) {
      for (int i = 0; i < plumberLatitudeList.length; i++) {
        double? plumberLatitude = plumberLatitudeList[i];
        double? plumberLongitude = plumberLongitudeList[i];

        if (plumberLatitude != null && plumberLongitude != null) {
          double distance = getVincentyDistance(
            plumberLatitude,
            plumberLongitude,
            userLatitude!,
            userLongitude!,
          );

          print('vicentyDistance from plumber $i to user: ${distance/1000} km');

          // Update the Firestore document with the calculated distance
          _updateDistanceInFirestore(i, distance);
        }
      }
    } else {
      print('No plumber locations available or user location missing.');
    }
  }


 
}


  

