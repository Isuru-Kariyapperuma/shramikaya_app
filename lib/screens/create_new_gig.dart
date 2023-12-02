import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shramikaya_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CreateNewGig extends StatefulWidget {
  const CreateNewGig({super.key});

  @override
  State<CreateNewGig> createState() => _CreateNewGigState();
}

class _CreateNewGigState extends State<CreateNewGig> {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("Radio and TV"), value: "Radio and TV"),
    DropdownMenuItem(child: Text("Gardening"), value: "Gardening"),
    DropdownMenuItem(child: Text("Computer"), value: "Computer"),
    DropdownMenuItem(child: Text("House and Home"), value: "House and Home"),
  ];

  TextEditingController _controllerJobName = new TextEditingController();
  TextEditingController _controllerMobileNumber = new TextEditingController();
  TextEditingController _controllerAddress = new TextEditingController();

  String selectedValue = "Radio and TV";
  String locationInfo = "Click 'Add Loacation' button!";
  late String lat;
  late String long;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error("Location Services are Disable");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showLocationServiceAlertDialog();
        return Future.error("Location Permissions are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "We cannot process the location because you denied it forever. Please give location access to the app using your mobile settings.");
    }

    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        lat = position.latitude.toString();
        long = position.longitude.toString();

        setState(() {
          locationInfo = "The location is set successfully.";
        });
      },
    );
  }

  Future<void> _openMap(String lat, String long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';

    await canLaunchUrlString(googleUrl)
        ? launchUrlString(googleUrl)
        : throw 'Could not lanuch $googleUrl';
  }

  void showLocationServiceAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Services Disabled"),
          content: Text("Please enable location services to use this app."),
          actions: [
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create New Gig",
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 5,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _controllerJobName,
                          maxLength: 30,
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: primaryColor),
                              hintText: "Title - කාර්යයේ නම"),
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DropdownButton(
                          isExpanded: true,
                          value: selectedValue,
                          items: menuItems,
                          hint: const Text("Choose the work Category"),
                          onChanged: (String? value) {
                            setState(() {
                              selectedValue = value!;
                            });
                          },
                          style: const TextStyle(
                              fontSize: 20, color: primaryColor),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: _controllerMobileNumber,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: primaryColor),
                              hintText: "Price - මිල"),
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // TextField(
                        //   controller: _controllerAddress,
                        //   maxLines: 5,
                        //   maxLength: 50,
                        //   decoration: const InputDecoration(
                        //       hintStyle: TextStyle(color: primaryColor),
                        //       hintText: "Address"),
                        //   style: const TextStyle(fontSize: 20),
                        // ),
                        Text(
                          locationInfo,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _getCurrentLocation().then((value) {
                                  lat = '${value.latitude}';
                                  long = '${value.longitude}';
                                  setState(() {
                                    locationInfo =
                                        "The location is set successfully.";
                                  });
                                  _liveLocation();
                                });
                              },
                              icon: const Icon(Icons.location_on),
                              label: const Text("Add Location"),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _openMap(lat, long);
                              },
                              icon: const Icon(Icons.map_outlined),
                              label: const Text("Open Map"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(295, 60),
                            textStyle: const TextStyle(
                              fontSize: 18,
                            ),
                            //padding: const EdgeInsets.all(16.0),
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                          onPressed: () {
                            final displayName = _controllerJobName.text;
                            final mobile = _controllerMobileNumber.text;
                            final address = _controllerAddress.text;
                            final jobCategory = selectedValue;
                            final profileImage =
                                FirebaseAuth.instance.currentUser!.photoURL!;
                            if (displayName != "" &&
                                mobile != "" &&
                                address != "") {
                              //Function call here
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please Fill All Fields!"),
                                  backgroundColor: primaryColor,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Create Gig"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
