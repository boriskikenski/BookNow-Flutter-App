import 'package:book_now/model/costumer.dart';
import 'package:book_now/model/favourites.dart';
import 'package:book_now/screens/profile_screen.dart';
import 'package:book_now/screens/reservations_screen.dart';
import 'package:book_now/service/reservation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/dto/reservation_dto.dart';

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
            onTap: () async {
              String? currentUser = FirebaseAuth.instance.currentUser?.email ?? '';
              Costumer? costumer = await Costumer.findByEmail(currentUser);
              Favourites? favorites = await Favourites.findByUserEmail(currentUser);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    costumer: costumer!,
                    favourites: favorites!,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Reservations'),
            onTap: () async {
              String? currentUser = FirebaseAuth.instance.currentUser?.email ?? '';
              List<ReservationDTO> reservations = await ReservationService.getAllReservationsForCostumer(currentUser);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservationsScreen(reservations: reservations),
                ),
              );
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
