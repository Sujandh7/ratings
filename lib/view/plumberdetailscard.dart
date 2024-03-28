import 'package:firebase/view/plumberDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/view/plumber.dart';
import '../util/string_const.dart';

class PlumberDetailsCard extends StatelessWidget {
  final PlumberDetails plumberDetails;
  final Map<String, dynamic>? userData; // Define userData here

  PlumberDetailsCard(this.plumberDetails, {this.userData});

  @override
  Widget build(BuildContext context) {
    Color statusColor = plumberDetails.available ? Colors.green : Colors.red;
    String statusText = plumberDetails.available ? 'Available' : 'Unavailable';
     String userName = userData?['displayName'] ?? 'Unknown User';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlumberDetailsScreen(
              plumberDetails: plumberDetails, // Corrected parameter name
            )
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: colorstr,
                backgroundImage: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDMrbabaGAWmEIwfvefFe-Wf9mYEDxeWv1Bc4QCmshjw&s"),
                child: Text('P'),
              ),
              title: Text(plumberDetails.name, style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(' (${plumberDetails.profession} )', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue),
                      Text(
                          ' ${plumberDetails.location}(${plumberDetails.distance.toStringAsFixed(2)} km away)'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green),
                      Text(' ${plumberDetails.contact}'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.timer, color: Colors.orange),
                      Text(' ${plumberDetails.experience} years'),
                    ],
                  ),
                  Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder(
                    future: getAverageRating(plumberDetails.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        double rating = snapshot.data as double;
                        return RatingBar.builder(
                          onRatingUpdate: (value) {},
                          initialRating: rating,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20,
                          ignoreGestures: true,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<double> getAverageRating(String plumberId) async {
    QuerySnapshot ratingSnapshot = await FirebaseFirestore.instance
        .collection("ratings")
        .where("plumberId", isEqualTo: plumberId)
        .get();
    double totalRating = 0;
    int ratingCount = 0;
    for (QueryDocumentSnapshot doc in ratingSnapshot.docs) {
      if (doc['rating'] != null && doc['rating'] is num) {
        totalRating += doc['rating'] as double;
        ratingCount++;
      }
    }
    return ratingCount > 0 ? totalRating / ratingCount : 0;
  }
}
