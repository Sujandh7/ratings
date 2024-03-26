// firestore_utils.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUtils {
  static void updatePlumberRating() async {
    CollectionReference plumbers = FirebaseFirestore.instance.collection('plumber');

    QuerySnapshot snapshot = await plumbers.get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String documentId = doc.id;

      await plumbers.doc(documentId).update({
        'rating': 0,
      }).then((value) {
        print("Rating field added to document $documentId");
      }).catchError((error) {
        print("Failed to add rating field to document $documentId: $error");
      });
    }
  }
}
