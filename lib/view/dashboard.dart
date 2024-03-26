import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase/util/string_const.dart';
import 'package:firebase/view/carousel.dart';
import 'package:firebase/view/carpenter.dart';
import 'package:firebase/view/drawer.dart';
import 'package:firebase/view/plumber.dart';
import 'package:firebase/view/profile.dart';
import 'package:firebase/view/searchpage.dart';

import 'package:firebase/view/see_all.dart';
import 'package:firebase/view/serviceprovidercategory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../provider/passwordvisibility.dart';
import 'mainUI.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  User? user;
  final List<String> imageUrl = [
    "asset/images/15%discount.jpg",
    "asset/images/Carpenter1.jpeg",
    "asset/images/water.jpg",
    "asset/images/clean.jpg",
    "asset/images/photography.jpg",
  ];
  @override
  void initState() {
    super.initState();
      var provider=Provider.of<Passwordvisibility>(context, listen: false);
        checkPermission(provider,Permission.location, context);
    user = FirebaseAuth.instance.currentUser;
  }

  Widget build(BuildContext context) {
    return Scaffold(



      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: colorstr,
        actions: [
          Row( 
            
            children: [
              Column(
                children: [
                  SizedBox(
                          width: MediaQuery.of(context).size.width*0.6,
                    
                    child: Text(
                      "Welcome,",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.waving_hand_outlined,
                          color: Colors.orange[400],
                          size: 20,
                        ),
                        SizedBox(
                          width: width(0.02, context),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.6,
                          child: Text("${user?.displayName ?? 'User'}", //welcome wala part
                          
style: TextStyle(fontSize: 15, color: Colors.white)),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width*0.4,
              // ),
            
               SizedBox(
                height: 65,
                width: 65,
                 child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),)),
                   child: Padding(
                     padding: const EdgeInsets.only(right:8.0),
                     child: Container( padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        shape: BoxShape.circle
                      ),
                       child: CircleAvatar(
                          backgroundImage: user?.photoURL != null &&
                                  user!.photoURL!.isNotEmpty
                              ? NetworkImage(user!.photoURL!)
                              : NetworkImage(
                                  "https://icons.veryicon.com/png/o/miscellaneous/wizhion/person-20.png"), // Provide a placeholder image URL
                          radius: 75,
                        ),
                     ),
                   ),
                 ),
               ),
            ],
          ),
        
        
        ],
      ),
      drawer: Mydrawer(),
      body: SafeArea(
        child: ui(),
      ),
    );
  }

  height(value, context) {
    return MediaQuery.of(context).size.height * value;
  }

  width(value, context) {
    return MediaQuery.of(context).size.width * value;
  }

  Widget ui() {
    return Stack(
      children: [
        Container(
          height: height(1, context),
          width: width(1, context),
          decoration: BoxDecoration(color: colorstr),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Container( 
                  
                    color: Colors.transparent,
                    width: width(1, context),
                    height: height(0.20, context),
                    child: carousel(context), // carousel ya call vaxa
                  ),
                ),
                SizedBox(
                  height: height(0.035, context),
                ),
                Container(
                  //3rd search wala
                  child: TextField(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        )),
                    cursorColor: colorstr,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.lime[50],
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 3),
                            borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.5, color: Colors.transparent),
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
                SizedBox(
                  height: height(0.015, context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Row(
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Spacer(),
                      GestureDetector(
                        child: Text("See All",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeeAll(),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15),
                  // 4th categories wala
                  height: height(0.34, context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PlumbersDetails() ,)),

                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.lightGreen[200],
                                        radius: 50,
                                        child: Image.asset(
                                          "asset/images/plumber.png",
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                        )),
                                    Text("Plumber",
                                        style: TextStyle(
                                            color: colorstr,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PainterDetails() ,)),
                                
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.lightGreen[200],
                                        radius: 50,
                                        child: Image.asset(
                                          "asset/images/painter.png",
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                        )),
                                    Text("Painter",
                                        style: TextStyle(
                                            color: colorstr,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CarpenterDetails() ,)),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.lightGreen[200],
                                        radius: 50,
                                        child: Image.asset(
                                          "asset/images/carpenter.png",
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                        )),
                                    Text("Carpenter",
                                        style: TextStyle(
                                            color: colorstr,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height(0.015, context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WaterTankerDetails() ,)),

                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.lightGreen[200],
                                        radius: 50,
                                        child: Image.asset(
                                          "asset/images/watertank.png",
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                        )),
                                    Text(
                                      "Water tanker",
                                      style: TextStyle(
                                          color: colorstr,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MechanicDetails() ,)),

                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.lightGreen[200],
                                        radius: 50,
                                        child: Image.asset(
                                          "asset/images/mechanic.png",
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                        )),
                                    Text("Mechanics",
                                        style: TextStyle(
                                            color: colorstr,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CleanerDetails() ,)),

                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.lightGreen[200],
                                        radius: 50,
                                        child: Image.asset(
                                          "asset/images/cleaning.png",
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                        )),
                                    Text("Cleaning",
                                        style: TextStyle(
                                            color: colorstr,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
                SizedBox(
                  height: height(0.018, context),
                ),
                Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                  height: MediaQuery.of(context).size.height*0.6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(style: BorderStyle.none,),
                   
                    
                    ),
                  child: Column(
                    children: [
                      Text("How we work",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
                      SizedBox(height: 25,)
                      ,SizedBox(
                        child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Column(
                               children: [
                                 CircleAvatar(
                                              backgroundColor:Colors.lightGreen[200],
                                              radius: 30,
                                              child: Image.asset(
                                                "asset/images/01 _register.png",
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                              )),
                                              SizedBox(height: 10,),
                                              Text("01",style: TextStyle(fontWeight: FontWeight.w500)),
                                              Text("Register",style: TextStyle(fontWeight: FontWeight.w500)),
                                              Text(""),
                                              
                               ],
                             ),
                             Column(
                               children: [
                                 CircleAvatar(
                                              backgroundColor:Colors.lightGreen[200],
                                              radius: 30,
                                              child: Image.asset(
                                                "asset/images/02_on_time.png",
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                              )),
                                              SizedBox(height: 10,),
                                              Text("02",style: TextStyle(fontWeight: FontWeight.w500)),
                                              Text("On Time",style: TextStyle(fontWeight: FontWeight.w500)),
                                              Text("Service",style: TextStyle(fontWeight: FontWeight.w500)),
                      
                      
                                              
                               ],
                             ),Column(
                               children: [
                                 CircleAvatar(
                                              backgroundColor:Colors.lightGreen[200],
                                              radius: 30,
                                              child: Image.asset(
                                                "asset/images/03_problem-solving.png",
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                              )),
                                              SizedBox(height: 10,),
                                              Text("03"),
                                              Text("Problem",style: TextStyle(fontWeight: FontWeight.w500)),
                                              Text("Solved",style: TextStyle(fontWeight: FontWeight.w500)),
                                              
                               ],
                             ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40,),
                      Divider(thickness: 1.5,),
                      SizedBox(height: 20,),
                    Column(
                    children: [
                      Text("Our Service Policy",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
                      SizedBox(height: 25,)
                      ,SizedBox(
                        child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Column(
                               children: [
                                 CircleAvatar(
                                              backgroundColor:Colors.lightGreen[200],
                                              radius: 30,
                                              child: Image.asset(
                                                "asset/images/thumbsup.png",
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                              )),
                                              SizedBox(height: 10,),
                                              Text("Quality",style: TextStyle(fontWeight: FontWeight.w500),),
                                              Text("Spares",style: TextStyle(fontWeight: FontWeight.w500)),
                                              
                                              
                               ],
                             ),
                             Column(
                               children: [
                                 CircleAvatar(
                                              backgroundColor:Colors.lightGreen[200],
                                              radius: 30,
                                              child: Image.asset(
                                                "asset/images/repair.png",
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                              )),
                                              SizedBox(height: 10,),
                                              Text("30 Day Repair",style: TextStyle(fontWeight: FontWeight.w500)),
                                              Text("Guarantee",style: TextStyle(fontWeight: FontWeight.w500)),
                                        
                      
                      
                                              
                               ],
                             ),Column(
                               children: [
                                 CircleAvatar(
                                              backgroundColor:Colors.lightGreen[200],
                                              radius: 30,
                                              child: Image.asset(
                                                "asset/images/reward.png",
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                              )),
                                              SizedBox(height: 10,),
                                              Text("Customer",style: TextStyle(fontWeight: FontWeight.w500)),
                                              Text("Satisfaction",style: TextStyle(fontWeight: FontWeight.w500)),
                                              
                      
                                              
                               ],
                             ),
                                    
                          ],
                        ),
                      )

                    ],
                  ),
SizedBox(height: 30,),
                               Text("know more",style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline ),)     

                    ],
                  ),
                  
                ),
                SizedBox(
                  height: height(0.001, context),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget carousel(context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        height: MediaQuery.of(context).size.height * 0.2,
        scrollDirection: Axis.horizontal,
        enlargeCenterPage: true,
        autoPlayCurve: Curves.fastLinearToSlowEaseIn,
        enableInfiniteScroll: true,
      ),
      items: imageUrl.map(
        (imageurls) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                //  margin: EdgeInsets.symmetric(horizontal: 5.0),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    imageurls,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ).toList(),
    );
  }
  Future<void> checkPermission(Passwordvisibility passwordvisibility,
      Permission permission, BuildContext context) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission().then((value) async {
        permission = await Geolocator.checkPermission();
      });
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await openAppSettings();
    } else {

      Position position = await Geolocator.getCurrentPosition();


      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {

        String address =
            "${placemarks.first.street}, ${placemarks.first.locality}";
        print("User's address: $address");
        passwordvisibility.setLocation(address);

      }
    }
  }


 
}

