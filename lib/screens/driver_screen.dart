import 'package:flutter/material.dart';
import 'package:mine_control/components/custom_appbar.dart';
import 'package:mine_control/components/drawer.dart';
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
      appBar: CustomAppBar(),
      drawer: DrawerCustom(),
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
                  style: TextStyle(color: Colors.white54)),
              trailing: Icon(Icons.arrow_forward_ios),
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
                  builder: (context) => DriverRegistrationScreen()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 5,
        backgroundColor: Colors.grey[700],
      ),
    );
  }
}
