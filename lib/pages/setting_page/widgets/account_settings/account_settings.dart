import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_setting_page.dart';

class AccountSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person, color: Colors.blue.shade800),
      title: Text('Account'),
      subtitle: Text('Manage your account settings'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigate to Account Settings Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountSettingsPage()), // Implement this page
        );
      },
    );
  }

}