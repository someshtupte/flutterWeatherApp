import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time, temp;
  final IconData icon;

  const HourlyForecastItem(
      {super.key, required this.icon, required this.time, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 75,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 10,
            ),
            Icon(
              icon,
              size: 20,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              temp,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
