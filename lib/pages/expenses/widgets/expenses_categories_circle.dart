import 'package:flutter/material.dart';

class ExpensesCategoriesCircle extends StatelessWidget {
  const ExpensesCategoriesCircle(
      {super.key, required this.circleIcons, required this.circlePercentage});
  final IconData circleIcons;
  final String circlePercentage;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            width: 70,
            height: 60,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  circleIcons,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  circlePercentage,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
