import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/text_field.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({Key? key}) : super(key: key);

  @override
  _VehicleRegistrationScreenState createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deviceIdController = TextEditingController();
  final _vehicleCategoryController = TextEditingController();
  final _licensePlateNumberController = TextEditingController();
  final _retentionPolicyController = TextEditingController();
  final _routeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Registration'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white54,
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'lib/assets/Background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RegisterTextField(
                        controller: _deviceIdController,
                        labelText: 'Device ID',
                        hintText: 'Enter the device ID',
                        prefixIcon: Icons.device_unknown,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the device ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      RegisterTextField(
                        controller: _licensePlateNumberController,
                        labelText: 'License Plate Number',
                        hintText: 'Enter the license plate number',
                        prefixIcon: Icons.confirmation_number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the license plate number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      RegisterTextField(
                        controller: _retentionPolicyController,
                        labelText: 'Retention Policy',
                        hintText: 'Enter the retention policy',
                        prefixIcon: Icons.policy,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the retention policy';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      RegisterTextField(
                        controller: _routeNameController,
                        labelText: 'Route Name',
                        hintText: 'Enter the route name',
                        prefixIcon: Icons.map,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the route name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _vehicleCategoryController.text.isEmpty
                            ? null
                            : _vehicleCategoryController.text,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'Vehicle Category',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Select the vehicle category',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(color: Colors.black, width: 3.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Colors.yellow.shade800, width: 2.0),
                          ),
                        ),
                        items: <String>['Truck', 'JCB', 'Van']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _vehicleCategoryController.text = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a vehicle category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 75.0),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Get a reference to the parent document
                            // DocumentReference vehicleRef = FirebaseFirestore
                            //     .instance
                            //     .collection('Vehicles')
                            //     .doc("1Uv8NXXoSVR2TD8Q8fO9");

                            // // Add a new document to the 'Vehicle' subcollection
                            // await vehicleRef.set({
                            //   'deviceId': _deviceIdController.text,
                            //   'vehicleCategory':
                            //       _vehicleCategoryController.text,
                            //   'licensePlateNumber':
                            //       _licensePlateNumberController.text,
                            //   'retentionPolicy':
                            //       _retentionPolicyController.text,
                            //   'routeName': _routeNameController.text,
                            //   'registrationTimestamp':
                            //       Timestamp.fromDate(DateTime.now()),
                            // }, SetOptions(merge: true));

                            CollectionReference vehicles = FirebaseFirestore
                                .instance
                                .collection('Vehicle');

                            // Add a new document to the 'Vehicles' collection
                            await vehicles.add({
                              'deviceId': _deviceIdController.text,
                              'vehicleCategory':
                                  _vehicleCategoryController.text,
                              'licensePlateNumber':
                                  _licensePlateNumberController.text,
                              'retentionPolicy':
                                  _retentionPolicyController.text,
                              'routeName': _routeNameController.text,
                              'registrationTimestamp':
                                  Timestamp.fromDate(DateTime.now()),
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Vehicle added successfully')),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          elevation: 20,
                          backgroundColor: Colors.red[300],
                          padding: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                        child: const Text('Register Vehicle'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
