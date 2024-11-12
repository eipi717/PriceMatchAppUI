import 'package:flutter/material.dart';

class AppSupport extends StatelessWidget {
  const AppSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // ListTile(
        //   leading: Icon(
        //       Icons.help,
        //       color: Colors.blue.shade800
        //   ),
        //   title: Text('Help Center'),
        //   onTap: () {
        //     // Navigate to Help Center Page or open a URL
        //   },
        // ),
        ListTile(
            leading: const Icon(
              Icons.feedback,
              color: Colors.grey,
              // color: Colors.blue.shade800
            ),
            title: Text('Send Feedback'),
            onTap: null
        ),
      ],
    );
  }
}