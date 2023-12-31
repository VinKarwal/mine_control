import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_control/components/text_field.dart';
import 'package:mine_control/screens/register_vehicle_screen.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Details"),
        elevation: 20,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Vehicle').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> vehicles = snapshot.data!.docs;

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> vehicle =
                  vehicles[index].data() as Map<String, dynamic>;

              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      bool switchValue = true;
                      final passwordController = TextEditingController();
                      const correctPassword =
                          'AlphaQ89'; // Replace with your password
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Text('Kill Switch',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold)),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Divider(
                                    color: Colors.grey[700],
                                    thickness: 1,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  RegisterTextField(
                                    controller: passwordController,
                                    obscureText: true,
                                    labelText: 'Password',
                                    hintText: 'Enter password',
                                    prefixIcon: Icons.lock,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the password';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  SwitchListTile(
                                    title: const Text('Immobilize'),
                                    value: switchValue,
                                    onChanged: (bool value) {
                                      setState(() {
                                        switchValue = value;
                                      });
                                      if (passwordController.text ==
                                          correctPassword) {
                                        // Update the field in your Firebase Realtime Database
                                        FirebaseDatabase.instance
                                            .ref()
                                            .child(
                                                "Markers/${vehicle['licensePlateNumber'].toString()}/power")
                                            .set(switchValue);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Vehicle immobilized successfully')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Incorrect password')),
                                        );
                                      }
                                    },
                                  ),
                                  Divider(
                                    color: Colors.grey[700],
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Column(
                      children: [
                        Image.asset(
                          "lib/assets/dump-truck(3).png",
                          height: 100,
                        ),
                        Text(
                          '${vehicle['licensePlateNumber']} (${vehicle['deviceId'].toString()})',
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                'Retention Policy: ${vehicle['retentionPolicy']}',
                                style: GoogleFonts.roboto(color: Colors.white)),
                            Text('Route: ${vehicle['routeName']}',
                                style: GoogleFonts.roboto(color: Colors.white)),
                            const Divider(
                              color: Colors.white54,
                              thickness: 2,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FutureBuilder<DatabaseEvent>(
                              future: FirebaseDatabase.instance
                                  .ref()
                                  .child(
                                      'Markers/${vehicle['licensePlateNumber']}')
                                  .once(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DatabaseEvent> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {
                                  if (snapshot.hasData) {
                                    DataSnapshot dataSnapshot =
                                        snapshot.data!.snapshot;
                                    if (dataSnapshot.value is Map) {
                                      Map<String, dynamic> data =
                                          Map<String, dynamic>.from(dataSnapshot
                                              .value as Map<dynamic, dynamic>);

                                      String speed = data['speed'].toString();
                                      String distance = data['dis'].toString();
                                      String totalDistance =
                                          data['totalDis'].toString();
                                      String todayDistance =
                                          data['todayDis'].toString();
                                      String weight = data['weight'].toString();

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            'Total Distance Travelled: $totalDistance',
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Distance Travelled Today: $todayDistance',
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Speed: $speed (Max. 80km/h)',
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Distance: $distance',
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Weight: $weight',
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Text('No data',
                                          style: GoogleFonts.roboto(
                                              color: Colors.white));
                                    }
                                  } else {
                                    return Text('No data',
                                        style: GoogleFonts.roboto(
                                            color: Colors.white));
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VehicleRegistrationScreen()));
        },
        elevation: 5,
        backgroundColor: Colors.grey[700],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
