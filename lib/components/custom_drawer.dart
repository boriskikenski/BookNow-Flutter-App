import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amberAccent,
              ),
              child: Text(
                'BookNow',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Make reservation'),
            onTap: () {
              Navigator.pushNamed(context, '/home/');
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile/');
            },
          ),
          ListTile(
            title: const Text('Reservations'),
            onTap: () {
              Navigator.pushNamed(context, '/reservations/');
            },
          ),
          ListTile(
            title: const Text('Create business'),
            onTap: () {
              Navigator.pushNamed(context, '/create-business/');
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
