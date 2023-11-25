import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/models.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

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
    updateMarker();
    _loadMarkers();
    databaseReference
        .child('Markers/UP22XY0002')
        .onChildChanged
        .listen((event) {
      _addOrUpdateMarker(event.snapshot);
    });
    super.initState();
  }

  void updateMarker() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) {
      databaseReference.child('Markers/UP22XY0002').update({
        'lat': position.latitude,
        'long': position.longitude,
      });
    });
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
    int missedCheckpoint = values['missed'];
    String vehicleStatus = values['vehiclestatus'];

    setState(() {
      _markers[markerId] = Marker(
        infoWindow: InfoWindow(title: markerId),
        markerId: MarkerId(markerId),
        position: LatLng(lat, lng),
        icon: markIcon,
      );

      if (_previousStatus[markerId] == 'Inside' && vehicleStatus == 'Outside') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 10),
                Text('$markerId is outside the fence'),
              ],
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.yellow[800],
          ),
        );
      }
      _previousStatus[markerId] = vehicleStatus;

      if (missedCheckpoint > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 10),
                Text('$markerId Missed checkpoint: $missedCheckpoint'),
              ],
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red[800],
          ),
        );
      }
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
              Polygon(
                polygonId: const PolygonId("#4"),
                points: checkpoint1,
                strokeWidth: 2,
                fillColor: Colors.brown.withOpacity(0.2),
                strokeColor: Colors.brown,
              ),
              Polygon(
                polygonId: const PolygonId("#4"),
                points: checkpoint2,
                strokeWidth: 2,
                fillColor: Colors.brown.withOpacity(0.2),
                strokeColor: Colors.brown,
              ),
              Polygon(
                polygonId: const PolygonId("#4"),
                points: checkpoint3,
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
                  padding: const EdgeInsets.all(8),
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
                  child: const Icon(
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
