import 'package:flutter/material.dart';
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
                        transitionDuration: const Duration(seconds: 1),
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: 
              ),
            ),
          ],
        ));
  }
}
