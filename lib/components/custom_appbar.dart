import 'package:flutter/material.dart';

AppBar CustomAppBar() {
  return AppBar(
    title: const Text("MineControl"),
    elevation: 20,
    backgroundColor: Colors.grey[900],
    foregroundColor: Colors.white,
    leading: Builder(
      builder: (context) => InkWell(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: const Icon(Icons.menu_rounded),
      ),
    ),
  );
}
