import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/Widget/customtextfield.dart';
import 'package:meatly/Widget/textfield.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/main.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  loc.LocationData? currentLocation;
  LatLng? initialCameraPosition;
  String? _address;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  void _fetchCurrentLocation() async {
    var location = loc.Location();
    loc.LocationData? currentLocation;

    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      print('Could not get the location: $e');
      currentLocation = null;
    }

    if (currentLocation != null) {
      setState(() {
        initialCameraPosition = LatLng(
          currentLocation!.latitude!,
          currentLocation!.longitude!,
        );
      });
      _getAddressFromLatLng(initialCameraPosition!);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        _address =
            "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print('Error getting address: $e');
      setState(() {
        _address = "Error fetching address";
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initialCameraPosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: initialCameraPosition!,
                  zoom: 14.0,
                ),
                onTap: (LatLng latLng) {
                  setState(() {
                    initialCameraPosition = latLng;
                  });
                  _getAddressFromLatLng(latLng);
                },
                markers: {
                  Marker(
                    markerId: MarkerId('selected-location'),
                    position: initialCameraPosition!,
                    draggable: true,
                    onDragEnd: (LatLng newPosition) {
                      setState(() {
                        initialCameraPosition = newPosition;
                      });
                      _getAddressFromLatLng(newPosition);
                    },
                  ),
                },
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TitleCard(
                    title: "Delivery Location",
                    onBack: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
            ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: MediaQuery.of(context).size.height / 5.5,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            _address ?? 'Fetching current location...',
                            style: AppTextStyle.text.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomButton(
                text: 'Enter Address',
                onPressed: () {
                  showBottomDrawer(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController _addressline1 = TextEditingController();
  TextEditingController _addressline2 = TextEditingController();
  TextEditingController _labelController = TextEditingController();
  bool saved = false;

  void showBottomDrawer(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        color: Colors.white,
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: saved
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: screenWidth * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Image.asset(
                    'lib/assets/images/success.png',
                    height: screenHeight * 0.17,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Address Added',
                    style: AppTextStyle.pageHeadingSemiBold,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your address has been saved as ",
                        style: AppTextStyle.labelText,
                      ),
                      Text(
                        "${_labelController.text}",
                        style: AppTextStyle.labelText.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  CustomButton(
                    text: "Done",
                    onPressed: () {
                      setState(() {
                        // card = true;
                      });
                      Navigator.pop(context);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const LoginSignup()),
                      // );
                    },
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: screenWidth * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: Text(
                      'Enter Address',
                      style: AppTextStyle.textSemibold20,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text("Address Line 1", style: AppTextStyle.labelText),
                  SizedBox(height: 5),
                  TextFeildStyle(
                    hintText: 'S1 American Dream Wy Suite F140',
                    controller: _addressline1,
                    height: 50,
                    onChanged: (value) {
                      setState(() {});
                    },
                    border: InputBorder.none,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text("Address Line 2", style: AppTextStyle.labelText),
                  SizedBox(height: 5),
                  TextFeildStyle(
                    hintText: '90 Dayton Ave, Passaic, New jersey, USA',
                    controller: _addressline2,
                    height: 50,
                    onChanged: (value) {
                      setState(() {});
                    },
                    border: InputBorder.none,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text("Label As", style: AppTextStyle.labelText),
                  SizedBox(height: 5),
                  CustomTextField(controller: _labelController, hint: 'Home'),
                  SizedBox(height: screenHeight * 0.03),
                  CustomButton(
                    text: "Save address",
                    onPressed: () async {
                      if (initialCameraPosition != null) {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(currentUserCredential)
                            .collection('Locations')
                            .add({
                          'address line 1': _addressline1.text,
                          'address line 2': _addressline2.text,
                          'label': _labelController.text,
                          'map location': GeoPoint(
                            initialCameraPosition!.latitude,
                            initialCameraPosition!.longitude,
                          ),
                        });
                        setState(() {
                          saved = true;
                        });
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
