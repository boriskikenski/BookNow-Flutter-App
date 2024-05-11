import 'package:book_now/components/custom_drawer.dart';
import 'package:book_now/model/enumerations/business_types.dart';
import 'package:book_now/model/favourites.dart';
import 'package:book_now/screens/business_screen.dart';
import 'package:book_now/screens/hotel_screen.dart';
import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../model/business.dart';
import '../model/costumer.dart';
import '../model/dto/business_checkout_dto.dart';
import '../model/dto/hotel_checkout_dto.dart';
import '../model/hotel.dart';
import '../service/business_hotel_service.dart';
import '../service/favourites_service.dart';
import 'business_checkout_screen.dart';
import 'hotel_checkout_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Costumer costumer;
  final Favourites favourites;
  const ProfileScreen({super.key, required this.costumer, required this.favourites});

  @override
  State<ProfileScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.yellow,
      appBar: CustomAppBar(
        title: 'BookNow',
        leadingOnPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.costumer.fullName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'username: ${widget.costumer.username}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'email: ${widget.costumer.email}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (widget.favourites.businessesFavourites.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Favourite businesses:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Card(
                  color: const Color.fromRGBO(255, 228, 0, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.favourites.businessesFavourites[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            BusinessCheckoutDTO business = await BHService.getBusinessCheckoutDTO(widget.favourites.businessesFavourites[index]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusinessCheckoutScreen(business: business),
                              ),
                            );
                          },
                          child: const Text('BookNow'),
                        ),
                      )
                    ],
                  ),
                );
              },
              childCount: widget.favourites.businessesFavourites.length,
            ),
          ),

          if (widget.favourites.businessesFavourites.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, top: 15),
                child: Text(
                  'Favourite hotels:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Card(
                  color: const Color.fromRGBO(255, 228, 0, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.favourites.hotelsFavourites[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            HotelCheckoutDTO hotel = await BHService.getHotelCheckoutDTO(widget.favourites.hotelsFavourites[index]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HotelCheckoutScreen(hotel: hotel),
                              ),
                            );
                          },
                          child: const Text('BookNow'),
                        ),
                      )
                    ],
                  ),
                );
              },
              childCount: widget.favourites.hotelsFavourites.length,
            ),
          ),

          if (widget.costumer.businessList.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, top: 15),
                child: Text(
                  'My business:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Card(
                  color: const Color.fromRGBO(255, 228, 0, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.costumer.businessList[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            Business? business = await Business.findByName(widget.costumer.businessList[index]);
                            bool isAlreadyFavourite = await FavouritesService.checkIsFavourite(
                              widget.costumer.businessList[index],
                              BusinessTypes.gym, //applicable for every business type that is not hotel
                            );
                            if (business != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BusinessScreen(
                                      business: business,
                                      isAlreadyFavourite: isAlreadyFavourite
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Open business profile'),
                        ),
                      )
                    ],
                  ),
                );
              },
              childCount: widget.costumer.businessList.length,
            ),
          ),

          if (widget.costumer.hotelList.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, top: 15),
                child: Text(
                  'My hotels:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Card(
                  color: const Color.fromRGBO(255, 228, 0, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.costumer.hotelList[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            Hotel? hotel = await Hotel.findByName(widget.costumer.hotelList[index]);
                            bool isAlreadyFavourite = await FavouritesService.checkIsFavourite(
                              widget.costumer.hotelList[index],
                              BusinessTypes.hotel,
                            );
                            if (hotel != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HotelScreen(
                                      hotel: hotel,
                                      isAlreadyFavourite: isAlreadyFavourite
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Open hotel profile'),
                        ),
                      )
                    ],
                  ),
                );
              },
              childCount: widget.costumer.hotelList.length,
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
    );
  }
}
