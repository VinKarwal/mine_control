import 'package:flutter/material.dart';
import 'package:mine_control/components/custom_appbar.dart';
import 'package:mine_control/components/drawer.dart';
import 'package:mine_control/screens/map_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: const DrawerCustom(),
      body: const MapScreen(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const RegistrationScreen()),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      //   backgroundColor: Colors.white,
      // ),
    );
  }
}
