import 'package:flutter/material.dart';
import 'package:mine_control/models/data_model.dart';
import 'package:mine_control/screens/register_driver_screen.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final List<Map<String, dynamic>> drivers = DemoData.drivers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Details"),
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
      body: ListView.builder(
        itemCount: drivers.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(drivers[index]['name'][0]),
              ),
              //bold text
              title: Text(
                drivers[index]['name'],
                style: const TextStyle(
                    color: Colors.white54, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  'License Number: ${drivers[index]['licenseNumber']}',
                  style: const TextStyle(color: Colors.white54)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to driver details page
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DriverRegistrationScreen()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 5,
        backgroundColor: Colors.grey[700],
      ),
    );
  }
}
