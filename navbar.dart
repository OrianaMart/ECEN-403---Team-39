import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.home_filled,
                color: Colors.amber),
            title: Text('Home'),
            onTap: () => print('Home Tapped'),

          ),
          ListTile(
            leading: const Icon(Icons.build_rounded,
                color: Colors.amber),
            title: Text('Equipment'),
            onTap: () => print('Equipment Tapped'),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_rounded,
                color: Colors.amber),
            title: Text('Forms'),
            onTap: () => print('Forms Tapped'),
          ),
          Divider(
          ),
          ListTile(
            leading: const Icon(Icons.person,
                color: Colors.amber),
            title: Text('Profile'),
            onTap: () => print('Profile Tapped'),
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded,
                color: Colors.amber),
            title: Text('Logout'),
            onTap: () => print('Logout Tapped'),
          ),
        ],
      ),
    );
  }
}