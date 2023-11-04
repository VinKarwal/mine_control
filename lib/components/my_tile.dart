import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  final String image;
  final String company;
  MyTile({super.key, required this.company, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey.shade800, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            child: Opacity(opacity: 0.6, child: Image.asset(image)),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Sign in with $company",
                style: TextStyle(color: Colors.grey[800], fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
