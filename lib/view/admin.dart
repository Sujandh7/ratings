import 'package:firebase/view/plumber.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Stream<QuerySnapshot> bookingRequests;

  @override
  void initState() {
    super.initState();
    // Listen to the 'plumber' collection for booking requests
    bookingRequests = FirebaseFirestore.instance
        .collection('plumber')
        .where('bookingPending', isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        backgroundColor: Colors.green, // Choose the desired color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookingRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No booking requests found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot request = snapshot.data!.docs[index];
              PlumberDetails plumberDetails =
                  PlumberDetails.fromMap(request.data() as Map<String, dynamic>);

              return BookingRequestCard(
                requestDocumentRef: request.reference,
                plumberDetails: plumberDetails,
              );
            },
          );
        },
      ),
    );
  }
}

class BookingRequestCard extends StatelessWidget {
  final DocumentReference requestDocumentRef;
  final PlumberDetails plumberDetails;

  BookingRequestCard({
    required this.requestDocumentRef,
    required this.plumberDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(plumberDetails.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location: ${plumberDetails.location}'),
                Text("Rating: ${plumberDetails.rating}"),
                Text('Contact: ${plumberDetails.contact}'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _handleAcceptRequest(requestDocumentRef);
            },
            child: Text('Accept Request'),
          ),
        ],
      ),
    );
  }

  void _handleAcceptRequest(DocumentReference requestDocumentRef) async {
    try {
      // Update the 'bookingPending' field to false (request accepted)
      await requestDocumentRef.update({'bookingPending': false});
      print('Request Accepted for ${plumberDetails.name}');
    } catch (e) {
      print('Error accepting request: $e');
    }
  }
}
