import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/states/auth_notifier.dart';
import '../../auth/login_page/login_page.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});


  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    void logout() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                // Perform logout
                authNotifier.logout();
                Navigator.pop(context);
                // Navigate to login or initial screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()), // Ensure you have a LoginPage
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return ListTile(
      leading: Icon(Icons.logout, color: Colors.red.shade700),
      title: Text('Logout'),
      onTap: logout
    );
  }
}