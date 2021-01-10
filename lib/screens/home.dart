import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ooptech/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  AuthService _auth = AuthService();

  // Geolocator geolocator = Geolocator(); instance can't be used in newer version

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng latlngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latlngPosition, zoom: 14.0);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition loc =
      CameraPosition(target: LatLng(34.0836708, 74.7972825), zoom: 21.0);

  Widget myPopMenu() {
    return PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            _auth.signOut();
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.print),
                      ),
                      Text('Print')
                    ],
                  )),
              PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.share),
                      ),
                      Text('Share')
                    ],
                  )),
              PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.add_circle),
                      ),
                      Text('Add')
                    ],
                  )),
            ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        actions: <Widget>[
          // FlatButton.icon(
          //   onPressed: () async {
          //     await _auth.signOut();

          //     // Navigator.of(context).pushReplacement(
          //     //     MaterialPageRoute(builder: (context) => Wrapper()));
          //   },
          //   icon: Icon(
          //     Icons.person,
          //     color: Colors.blueGrey[100],
          //   ),
          //   label: Text(
          //     "Log Out",
          //     style: TextStyle(color: Colors.blueGrey[100]),
          //   ),
          // ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.delete),
                      ),
                      Text('Delete Account')
                    ],
                  )),
              PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.logout),
                      ),
                      Text('Log Out')
                    ],
                  )),
            ],
            onSelected: (value) async {
              if (value == 1) {
                await _auth.deleteuseraccount();
                Get.snackbar('Success', 'User Account Successfully Deleted');
              }
              if (value == 2) {
                await _auth.signOut();
                Get.snackbar('Sucsess', 'Log Out Successfully');
              }
            },
          )
        ],
        title: Text(
          'OopTech',
          style: TextStyle(
              fontFamily: 'Signatra',
              letterSpacing: 2.0,
              fontSize: 50.0,
              color: Colors.blueGrey[900]),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Google Maps",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 3.0),
                    borderRadius: BorderRadius.circular(7.0)),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.6,
                padding: EdgeInsets.all(5.0),
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controllerGoogleMap.complete(controller);
                    newGoogleMapController = controller;
                    locatePosition();
                  },
                  mapType: MapType.normal,
                  initialCameraPosition: loc,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  compassEnabled: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("App Created By Abrar Altaf Lone"),
              ),
              SizedBox(height: 35),
              Text(
                "Note : Make Sure Location Permission Is Enabled",
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
