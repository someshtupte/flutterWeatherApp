import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String label, temperature;

  const AdditionalInfo(
      {super.key,
      required this.icon,
      required this.label,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 105,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                temperature,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
