import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shramikaya_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  var _controllerLocation = new TextEditingController();

  String selectedValue = "Radio and TV";
  String locationInfo = "Click 'Add Loacation' button!";
  late String lat;
  late String long;
  String country = '';
  String name = '';
  String street = '';
  String postalCode = '';
  var uuid = new Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];
  bool isVisibale = true;

  @override
  void initState() {
    super.initState();
    _controllerLocation.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controllerLocation.text);
    setState(() {
      isVisibale = true;
    });
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyCg3dIaZTzWGRAFeL8UvqUj9LYt2k4PxXM";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

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
          locationInfo = street;
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

  Future<void> getLocation() async {
    double latNum = double.parse(lat);
    double longNum = double.parse(long);

    List<Placemark> placemark = await placemarkFromCoordinates(latNum, longNum);

    print("Country " + placemark[0].country.toString());
    print("Name " + placemark[0].name.toString());
    print("Street " + placemark[0].street.toString());
    print("PostalCode " + placemark[0].postalCode.toString());

    setState(() {
      country = placemark[0].country!;
      name = placemark[0].name!;
      street = placemark[0].street!;
      postalCode = placemark[0].postalCode!;
    });
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
                        TextField(
                          controller: _controllerLocation,
                          maxLength: 30,
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: primaryColor),
                              hintText: "Location - ස්ථානය"),
                          style: const TextStyle(fontSize: 20),
                        ),
                        Visibility(
                          visible: isVisibale,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _placeList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _controllerLocation.text =
                                        _placeList[index]["description"];
                                    isVisibale = false;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                                child: ListTile(
                                  title: Text(_placeList[index]["description"]),
                                ),
                              );
                            },
                          ),
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
                            final address = _controllerLocation.text;
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
