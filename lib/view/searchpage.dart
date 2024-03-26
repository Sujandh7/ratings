import 'package:firebase/util/string_const.dart';
import 'package:firebase/view/plumber.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'PlumberDetailsCard.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool showImage = true;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorstr,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500),
                      border: Border.all(color: colorstr),
                      boxShadow: [
                        BoxShadow(
                          blurStyle: BlurStyle.outer,
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 100,
                        )
                      ]),
                  child: Image.asset(
                    'asset/images/logo.png',
                    height: 150,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            if (showImage)
              Padding(
                padding: const EdgeInsets.only(top: 100, left: 15, right: 5),
                child: SizedBox(
                  child: Image(
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/test-46b26.appspot.com/o/1000011072.png?alt=media&token=9a9afb94-8e25-4d9a-904f-75ea12b5dd5f"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                  child: TextField(
                    cursorColor: colorstr,
                    controller: searchController,
                    onChanged: (value) {
                      // Call search function when text changes
                      searchProfession(value);
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.lime[50],
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colorstr, width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.5, color: Colors.green),
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: colorstr,
                        ),
                        hintText: "All Service Available",
                        hintStyle:
                            TextStyle(fontSize: 20, color: Colors.black38),
                        suffixIcon: Icon(
                          FontAwesomeIcons.search,
                          color: colorstr,
                        )),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("plumber")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No plumber details found in Firestore.'),
                            ElevatedButton(
                              onPressed: () {
                                // Implement any action you want when the button is pressed
                              },
                              child: Text('Button'),
                            ),
                          ],
                        ));
                      }

                      // Create a list to store plumber details
                      List<PlumberDetails> plumberDetailsList = [];

                      // Iterate through the documents and add plumber details to the list
                      snapshot.data!.docs.forEach((doc) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
                        PlumberDetails plumberDetails =
                            PlumberDetails.fromMap(data);

                        // Check if the profession name contains the first two letters of the search text
                        if (searchController.text.length >= 2 &&
                            plumberDetails.profession.toLowerCase().startsWith(
                                searchController.text
                                    .toLowerCase()
                                    .substring(0, 2))) {
                          plumberDetailsList.add(plumberDetails);
                        }
                      });

                      // Sort plumber details by star rating (highest first)
                      plumberDetailsList.sort((a, b) {
                        // Ensure rating values are double types
                        double aRating = a.rating.toDouble();
                        double bRating = b.rating.toDouble();

                        if (aRating == bRating) {
                          // If ratings are equal, compare distances
                          return a.distance.compareTo(b.distance);
                        } else {
                          // Otherwise, compare ratings
                          return bRating.compareTo(aRating);
                        }
                      }
                      );

                      return ListView.builder(
                        itemCount: plumberDetailsList.length,
                        itemBuilder: (context, index) {
                          PlumberDetails plumberDetails =
                              plumberDetailsList[index];
                          return PlumberDetailsCard(plumberDetails);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to search based on the first two letters of the profession name
  void searchProfession(String searchTerm) {
    setState(() {
      // Trigger a rebuild with the updated search term
      showImage = searchTerm.isEmpty;
    });
  }
}
