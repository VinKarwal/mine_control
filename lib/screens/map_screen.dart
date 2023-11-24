import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/models.dart';
import 'package:firebase_database/firebase_database.dart';

class MapScreen extends StatefulWidget {
  final bool showBackButton;
  const MapScreen({Key? key, this.showBackButton = true}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor markIcon = BitmapDescriptor.defaultMarker;
  Map<String, Marker> _markers = <String, Marker>{};
  Map<String, String> _previousStatus = {};

  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    addIcon();
    // updateMarker();
    _loadMarkers();
    super.initState();
  }

  void _loadMarkers() {
    databaseReference.child('Markers').onChildAdded.listen((event) {
      _addOrUpdateMarker(event.snapshot);
    });

    databaseReference.child('Markers').onChildChanged.listen((event) {
      _addOrUpdateMarker(event.snapshot);
    });
  }

  void _addOrUpdateMarker(DataSnapshot snapshot) {
    Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

    double lat = values['lat'];
    double lng = values['long'];
    String markerId = snapshot.key!;
    String vehicleStatus = values['vehiclestatus'];

    setState(() {
      _markers[markerId] = Marker(
        infoWindow: InfoWindow(title: markerId),
        markerId: MarkerId(markerId),
        position: LatLng(lat, lng),
        icon: markIcon,
      );

      if (_previousStatus[markerId] == 'Inside' && vehicleStatus == 'Outside') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
            return AlertDialog(
              title: Text(
                'Alert!',
                style: TextStyle(
                    color: Colors.red[800], fontWeight: FontWeight.bold),
              ),
              content: Text(
                '$markerId is outside the fence',
              ),
            );
          },
        );
      }
      _previousStatus[markerId] = vehicleStatus;
    });
  }

  void addIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "lib/assets/dump-truck(1).png")
        .then((icon) {
      setState(() {
        markIcon = icon;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(24.339515, 72.879537),
              zoom: 15.5,
            ),
            markers: _markers.values.toSet(),
            polygons: {
              Polygon(
                polygonId: const PolygonId("#1"),
                points: polyPoints1,
                strokeWidth: 2,
                fillColor: Colors.green.withOpacity(0.2),
                strokeColor: Colors.green,
              ),
              Polygon(
                polygonId: const PolygonId("#2"),
                points: polyPoints2,
                strokeWidth: 2,
                fillColor: Colors.yellow.withOpacity(0.2),
                strokeColor: Colors.yellow.shade800,
              ),
              Polygon(
                polygonId: const PolygonId("#3"),
                points: polyPoints3,
                strokeWidth: 2,
                fillColor: Colors.orange.withOpacity(0.2),
                strokeColor: Colors.orange,
              ),
              Polygon(
                polygonId: const PolygonId("#4"),
                points: polyPoints4,
                strokeWidth: 2,
                fillColor: Colors.brown.withOpacity(0.2),
                strokeColor: Colors.brown,
              ),
            },
          ),
          if (widget.showBackButton)
            Positioned(
              top: 40.0,
              left: 10.0,
              child: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(2, 3), // changes position of shadow
                        ),
                      ]),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
        ],
      ),
    );
  }
}
