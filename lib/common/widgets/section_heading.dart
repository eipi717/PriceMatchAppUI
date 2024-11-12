import 'package:flutter/cupertino.dart';

class SectionHeading extends StatelessWidget {
  final String sectionTitle;

  final double paddingNumber;

  const SectionHeading(this.sectionTitle, this.paddingNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(paddingNumber),
      child: Text(
        sectionTitle,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}