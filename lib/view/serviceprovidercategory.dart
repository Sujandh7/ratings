import 'package:firebase/util/string_const.dart';
import 'package:firebase/view/plumber.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PlumberDetailsCard.dart';

class CarpenterDetails extends StatefulWidget {
  @override
  _CarpenterDetailsState createState() => _CarpenterDetailsState();
}
class _CarpenterDetailsState extends State<CarpenterDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorstr,
        foregroundColor: Colors.white,
        title: Text("Capenter Details", ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
             
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("plumber").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No plumber details found in Firestore.'));
                    }

                    // Create a list to store carpenter details
                    List<PlumberDetails> carpenterDetailsList = [];

                    // Iterate through the documents and add carpenter details to the list
                    snapshot.data!.docs.forEach((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      PlumberDetails plumberDetails = PlumberDetails.fromMap(data);

                      // Check if the profession is "carpenter"
                      if (plumberDetails.profession.toLowerCase() == "carpenter") {
                        carpenterDetailsList.add(plumberDetails);
                      }
                    });

                    // Sort carpenter details by distance (smallest distance first)
                    carpenterDetailsList.sort((a, b) => a.distance.compareTo(b.distance));

                    return ListView.builder(
                      itemCount: carpenterDetailsList.length,
                      itemBuilder: (context, index) {
                        PlumberDetails plumberDetails = carpenterDetailsList[index];
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
    );
  } 
}


class CleanerDetails extends StatefulWidget {
  @override
  _CleanerDetailsState createState() => _CleanerDetailsState();
}
class _CleanerDetailsState extends State<CleanerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorstr,
        foregroundColor: Colors.white,
        title: Text("Cleaner Details", ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
             
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("plumber").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No plumber details found in Firestore.'));
                    }

                    // Create a list to store carpenter details
                    List<PlumberDetails> cleanerDetailsList = [];

                    // Iterate through the documents and add carpenter details to the list
                    snapshot.data!.docs.forEach((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      PlumberDetails plumberDetails = PlumberDetails.fromMap(data);

                      // Check if the profession is "carpenter"
                      if (plumberDetails.profession.toLowerCase() == "cleaner") {
                        cleanerDetailsList.add(plumberDetails);
                      }
                    });

                    // Sort carpenter details by distance (smallest distance first)
                    cleanerDetailsList.sort((a, b) => a.distance.compareTo(b.distance));

                    return ListView.builder(
                      itemCount: cleanerDetailsList.length,
                      itemBuilder: (context, index) {
                        PlumberDetails plumberDetails = cleanerDetailsList[index];
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
    );
  } 
}


class PainterDetails extends StatefulWidget {
  @override
  _PainterDetailsState createState() => _PainterDetailsState();
}
class _PainterDetailsState extends State<PainterDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorstr,
        foregroundColor: Colors.white,
        title: Text("Painter Details", ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
             
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("plumber").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No plumber details found in Firestore.'));
                    }

                    // Create a list to store carpenter details
                    List<PlumberDetails> PainterDetailsList = [];

                    // Iterate through the documents and add carpenter details to the list
                    snapshot.data!.docs.forEach((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      PlumberDetails plumberDetails = PlumberDetails.fromMap(data);

                      // Check if the profession is "carpenter"
                      if (plumberDetails.profession.toLowerCase() == "painter") {
                        PainterDetailsList.add(plumberDetails);
                      }
                    });

                    // Sort carpenter details by distance (smallest distance first)
                    PainterDetailsList.sort((a, b) => a.distance.compareTo(b.distance));

                    return ListView.builder(
                      itemCount: PainterDetailsList.length,
                      itemBuilder: (context, index) {
                        PlumberDetails plumberDetails = PainterDetailsList[index];
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
    );
  } 
}
class PlumbersDetails extends StatefulWidget {
  @override
  _PlumbersDetailsState createState() => _PlumbersDetailsState();
}
class _PlumbersDetailsState extends State<PlumbersDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorstr,
        foregroundColor: Colors.white,
        title: Text("Plumbers Details", ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
             
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("plumber").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No plumber details found in Firestore.'));
                    }

                    // Create a list to store carpenter details
                    List<PlumberDetails> PlumbersDetailsList = [];

                    // Iterate through the documents and add carpenter details to the list
                    snapshot.data!.docs.forEach((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      PlumberDetails plumberDetails = PlumberDetails.fromMap(data);

                      // Check if the profession is "carpenter"
                      if (plumberDetails.profession.toLowerCase() == "plumber") {
                        PlumbersDetailsList.add(plumberDetails);
                      }
                    });

                    // Sort carpenter details by distance (smallest distance first)
                    PlumbersDetailsList.sort((a, b) => a.distance.compareTo(b.distance));

                    return ListView.builder(
                      itemCount: PlumbersDetailsList.length,
                      itemBuilder: (context, index) {
                        PlumberDetails plumberDetails = PlumbersDetailsList[index];
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
    );
  } 
}

class WaterTankerDetails extends StatefulWidget {
  @override
  _WaterTankerDetailsState createState() => _WaterTankerDetailsState();
}
class _WaterTankerDetailsState extends State<WaterTankerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorstr,
        foregroundColor: Colors.white,
        title: Text("Water Tanker Details", ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
             
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("plumber").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No plumber details found in Firestore.'));
                    }

                    // Create a list to store carpenter details
                    List<PlumberDetails> WaterTankerDetailsList = [];

                    // Iterate through the documents and add carpenter details to the list
                    snapshot.data!.docs.forEach((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      PlumberDetails plumberDetails = PlumberDetails.fromMap(data);

                      // Check if the profession is "carpenter"
                      if (plumberDetails.profession.toLowerCase() == "water tanker") {
                        WaterTankerDetailsList.add(plumberDetails);
                      }
                    });

                    // Sort carpenter details by distance (smallest distance first)
                    WaterTankerDetailsList.sort((a, b) => a.distance.compareTo(b.distance));

                    return ListView.builder(
                      itemCount: WaterTankerDetailsList.length,
                      itemBuilder: (context, index) {
                        PlumberDetails plumberDetails = WaterTankerDetailsList[index];
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
    );
  } 
}
class MechanicDetails extends StatefulWidget {
  @override
  _MechanicDetailsState createState() => _MechanicDetailsState();
}
class _MechanicDetailsState extends State<MechanicDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorstr,
        foregroundColor: Colors.white,
        title: Text("Mechanic Details", ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
             
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("plumber").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No plumber details found in Firestore.'));
                    }

                    // Create a list to store carpenter details
                    List<PlumberDetails> MechanicDetailsList = [];

                    // Iterate through the documents and add carpenter details to the list
                    snapshot.data!.docs.forEach((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      PlumberDetails plumberDetails = PlumberDetails.fromMap(data);

                      // Check if the profession is "carpenter"
                      if (plumberDetails.profession.toLowerCase() == "mechanic") {
                        MechanicDetailsList.add(plumberDetails);
                      }
                    });

                    // Sort carpenter details by distance (smallest distance first)
                    MechanicDetailsList.sort((a, b) => a.distance.compareTo(b.distance));

                    return ListView.builder(
                      itemCount: MechanicDetailsList.length,
                      itemBuilder: (context, index) {
                        PlumberDetails plumberDetails = MechanicDetailsList[index];
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
    );
  } 
}
class PhotographerDetails extends StatefulWidget {
  @override
  _PhotographerDetailsState createState() => _PhotographerDetailsState();
}
class _PhotographerDetailsState extends State<PhotographerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorstr,
        foregroundColor: Colors.white,
        title: Text("Photographer Details", ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
             
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("plumber").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No plumber details found in Firestore.'));
                    }

                    // Create a list to store carpenter details
                    List<PlumberDetails> PhotographerDetailsList = [];

                    // Iterate through the documents and add carpenter details to the list
                    snapshot.data!.docs.forEach((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      PlumberDetails plumberDetails = PlumberDetails.fromMap(data);

                      // Check if the profession is "carpenter"
                      if (plumberDetails.profession.toLowerCase() == "photographer") {
                        PhotographerDetailsList.add(plumberDetails);
                      }
                    });

                    // Sort carpenter details by distance (smallest distance first)
                    PhotographerDetailsList.sort((a, b) => a.distance.compareTo(b.distance));

                    return ListView.builder(
                      itemCount: PhotographerDetailsList.length,
                      itemBuilder: (context, index) {
                        PlumberDetails plumberDetails = PhotographerDetailsList[index];
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
    );
  } 
}








