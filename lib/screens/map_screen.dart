import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/models.dart';
import 'package:firebase_database/firebase_database.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

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

  // void updateMarker() {
  //   // Listen to the database reference
  //   databaseReference.child('location').onValue.listen((event) {
  //     var snapshot = event.snapshot;

  //     // Get the new location data
  //     double newLat = snapshot.value['lat'];
  //     double newLng = snapshot.value['lng'];

  //     // Update the marker location
  //     setState(() {
  //       // Assuming you have a marker with markerId 'marker_1'
  //       Marker(
  //         markerId: const MarkerId('#1 01'),
  //         position: LatLng(newLat, newLng),
  //         icon: markIcon,
  //       );
  //     });
  //   });
  // }

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
      // if (vehicleStatus == 'Outside') {
      //   final snackBar = SnackBar(
      //     content: Text('$markerId is outside the fence'),
      //     duration: Duration(seconds: 1),
      //   );
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }
      // if (_previousStatus[markerId] == 'inside' && vehicleStatus == 'outside') {
      //   final snackBar = SnackBar(
      //     content: Text('$markerId is outside the fence'),
      //     duration: Duration(seconds: 1),
      //   );
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }

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
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: LatLng(24.339515, 72.879537),
          zoom: 15.5,
        ),
        markers: _markers.values.toSet(),
        // {
        //   Marker(
        //     markerId: const MarkerId("#1 01"),
        //     position: const LatLng(24.339515, 72.879537),
        //     draggable: true,
        //     icon: markIcon,
        //   ),
        //   Marker(
        //     markerId: const MarkerId("#1 02"),
        //     position: const LatLng(24.339198, 72.878810),
        //     draggable: true,
        //     icon: markIcon,
        //   ),
        //   Marker(
        //     markerId: const MarkerId("#2 01"),
        //     position: const LatLng(24.339529, 72.881167),
        //     draggable: true,
        //     icon: markIcon,
        //   ),
        //   Marker(
        //     markerId: const MarkerId("#2 02"),
        //     position: const LatLng(24.339710, 72.881499),
        //     draggable: true,
        //     icon: markIcon,
        //   ),
        //   Marker(
        //     markerId: const MarkerId("#3 01"),
        //     position: const LatLng(24.341278, 72.877073),
        //     draggable: true,
        //     icon: markIcon,
        //   ),
        //   Marker(
        //     markerId: const MarkerId("#3 02"),
        //     position: const LatLng(24.340688, 72.877191),
        //     draggable: true,
        //     icon: markIcon,
        //   ),
        //   Marker(
        //     markerId: const MarkerId("#4 01"),
        //     position: const LatLng(24.343260, 72.874863),
        //     draggable: true,
        //     icon: markIcon,
        //   ),
        //   Marker(
        //     markerId: const MarkerId("#4 02"),
        //     position: const LatLng(24.343819, 72.875963),
        //     draggable: true,
        //     icon: markIcon,
        //   ),
        // },
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
    );
  }
}
