import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/text_field.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({Key? key}) : super(key: key);

  @override
  _DriverRegistrationScreenState createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _licenseController = TextEditingController();
  final _expiryController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Registration'),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RegisterTextField(
                      controller: _nameController,
                      labelText: 'Name',
                      hintText: 'Enter the driver\'s name',
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the driver\'s name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    RegisterTextField(
                      controller: _licenseController,
                      labelText: 'License',
                      hintText: 'Enter the driver\'s license',
                      prefixIcon: Icons.confirmation_number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the driver\'s license';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    RegisterTextField(
                      controller: _expiryController,
                      labelText: 'Expiry',
                      hintText: 'Enter the license expiry date',
                      prefixIcon: Icons.date_range,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the license expiry date';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    RegisterTextField(
                      controller: _dobController,
                      labelText: 'Date of Birth',
                      hintText: 'Enter the driver\'s date of birth',
                      prefixIcon: Icons.calendar_today,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the driver\'s date of birth';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    RegisterTextField(
                      controller: _addressController,
                      labelText: 'Address',
                      hintText: 'Enter the driver\'s address',
                      prefixIcon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the driver\'s address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    RegisterTextField(
                      controller: _contactController,
                      labelText: 'Contact',
                      hintText: 'Enter the driver\'s contact number',
                      prefixIcon: Icons.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the driver\'s contact number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50.0),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await FirebaseFirestore.instance
                              .collection('Drivers')
                              .add({
                            'name': _nameController.text,
                            'license': _licenseController.text,
                            'expiry': _expiryController.text,
                            'dob': _dobController.text,
                            'address': _addressController.text,
                            'contact': _contactController.text,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Driver added successfully')),
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
                      child: const Text('Register Driver'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
