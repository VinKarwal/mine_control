import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:mine_control/components/custom_appbar.dart';
import 'package:mine_control/components/drawer.dart';
import 'package:mine_control/components/text_field.dart';
import 'package:mine_control/models/data_model.dart';
import 'package:mine_control/screens/register_vehicle_screen.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  // final List<Map<String, dynamic>> vehicles = DemoData.vehicles;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // void immobilizeVehicle() async {
  //   String message =
  //       'The vehicle has been immobilized due to suspicious activities.';
  //   List<String> recipients = ['8847252495'];

  //   String result = await sendSMS(message: message, recipients: recipients)
  //       .catchError((onError) {
  //     print(onError);
  //   });
  //   print(result);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: const DrawerCustom(),
      backgroundColor: Colors.grey[300],
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Vehicle').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
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
                            title: const Text('Kill Switch',
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                                                "/${vehicle['licensePlateNumber'].toString()}/vehiclecontrol")
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
                    leading: Image.asset(
                      "lib/assets/dump-truck(3).png",
                    ),
                    title: Text(
                      '${vehicle['deviceId']} ${vehicle['vehicleCategory']} (${vehicle['licensePlateNumber'].toString()})',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Divider(
                          color: Colors.white54,
                          thickness: 2,
                        ),
                        Text('Retention Policy: ${vehicle['retentionPolicy']}',
                            style: const TextStyle(color: Colors.white)),
                        Text('Route: ${vehicle['routeName']}',
                            style: const TextStyle(color: Colors.white)),
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
