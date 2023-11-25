import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_control/components/drawer.dart';
import 'package:mine_control/screens/map_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: const DrawerCustom(),
        backgroundColor: Colors.blueGrey[100],
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              backgroundColor: Colors.grey[900],
              foregroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: const Icon(
                  Icons.menu_rounded,
                  size: 30,
                ),
              ),
              floating: true,
              elevation: 20,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  'https://images.unsplash.com/photo-1587919968590-fbc98cea6c9a?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fG1pbmluZ3xlbnwwfHwwfHx8MA%3D%3D',
                  fit: BoxFit.fill,
                ),
                title: const Text(
                  'MineControl',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
            ),
            // const SliverToBoxAdapter(
            //   child: CustomCarousel(),
            // ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onLongPress: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) =>
                            const MapScreen(showBackButton: true),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.brown[300],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Hero(
                        tag: 'map',
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: const MapScreen(
                            showBackButton: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Container(
                  height: 400,
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Overall')
                        .doc('jwBdfrKMU8OZqjk8bY5f')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Card(
                          color: Colors.grey[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                        'https://cdn1.iconfinder.com/data/icons/cryptocurrency-blockchain-fintech/32/Cryptocurrency_mining-08-64.png'),
                                    SizedBox(width: 35),
                                    Text(
                                      'Overall Data',
                                      style: GoogleFonts.sen(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.white),
                                SizedBox(height: 10),
                                Text(
                                  '◓ Checkpoints: ${data['checkpoints']}',
                                  style: GoogleFonts.sen(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '◓ Fences: ${data['fences']}',
                                  style: GoogleFonts.sen(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '◓ Total Distance: ${data['totalDis']}',
                                  style: GoogleFonts.sen(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '◓ Total Today: ${data['totalToday']}',
                                  style: GoogleFonts.sen(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '◓ Working Drivers: ${data['workingDrivers']}',
                                  style: GoogleFonts.sen(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '◓ Working Vehicles: ${data['workingVehicles']}',
                                  style: GoogleFonts.sen(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
