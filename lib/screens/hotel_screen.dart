import 'package:book_now/model/dto/hotel_checkout_dto.dart';
import 'package:book_now/model/hotel.dart';
import 'package:book_now/screens/hotel_checkout_screen.dart';
import 'package:book_now/screens/hotel_edit_screen.dart';
import 'package:book_now/screens/qr_code_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';
import '../model/costumer.dart';
import '../model/favourites.dart';
import '../model/review.dart';
import '../service/business_hotel_service.dart';
import '../service/image_service.dart';
import '../service/website_service.dart';

class HotelScreen extends StatefulWidget {
  final Hotel hotel;
  final bool isAlreadyFavourite;
  const HotelScreen({super.key, required this.hotel, required this.isAlreadyFavourite});

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final TextEditingController _reviewComment;
  int _numberOfStars = 0;
  Color _starOneColor = Colors.yellow;
  Color _starTwoColor = Colors.yellow;
  Color _starThreeColor = Colors.yellow;
  Color _starFourColor = Colors.yellow;
  Color _starFiveColor = Colors.yellow;
  late bool _isFavourite;
  late bool _isCurrentUserOwner;


  @override
  void initState() {
    _reviewComment = TextEditingController();
    _isFavourite = widget.isAlreadyFavourite;
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (widget.hotel.ownerEmail == currentUserEmail) {
      _isCurrentUserOwner = true;
    } else {
      _isCurrentUserOwner = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    _reviewComment.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isCurrentUserOwner)
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRScanScreen(scanForBusiness: widget.hotel.hotelName),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('Verify reservation'),
                    )
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    widget.hotel.hotelName,
                    style: const TextStyle(fontSize: 28 , fontWeight: FontWeight.bold),
                  ),
                ),
                if (_isFavourite)
                  ElevatedButton(
                    onPressed: () {
                      Favourites.deleteFavourite(widget.hotel.hotelName, widget.hotel.filter);
                      setState(() {
                        _isFavourite = !_isFavourite;
                      });
                    },
                    child: const Text('Remove from FAV'),
                  ),
                if (!_isFavourite)
                  ElevatedButton(
                    onPressed: () {
                      Favourites.saveFavourite(widget.hotel.hotelName, widget.hotel.filter);
                      setState(() {
                        _isFavourite = !_isFavourite;
                      });
                    },
                    child: const Text('Add to FAV'),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Image.memory(
                ImageService.imageFromBase64String(widget.hotel.encodedImage),
                width: 365,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            const Text(
              'Price per room:',
              style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),
            ),
            Column(
              children: widget.hotel.rooms.map((room) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${room.capacity} bed: ${room.pricePerNight.toString()} \$',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                );
              }).toList(),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                'Website:',
                style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: GestureDetector(
                onTap: () async {
                  await WebsiteService.launchWebsite(context, Uri.parse(widget.hotel.website));
                },
                child: Text(
                  widget.hotel.website,
                  style: const TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
            ),

            const Text(
              'Working hours:',
              style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                '${widget.hotel.openingTime.hour..toString()}:${widget.hotel.openingTime.minute.toString().toString()} - '
                    '${widget.hotel.closingTime.hour.toString()}:${widget.hotel.closingTime.minute.toString()}',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            const Text(
              'Location:',
              style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),
            ),
            Text(
              'country: ${widget.hotel.location.country} ',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'city: ${widget.hotel.location.city} ',
              style: const TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                'street: ${widget.hotel.location.street} ${widget.hotel.location.streetNumber}',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            if (_isCurrentUserOwner)
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelEditScreen(existingHotel: widget.hotel),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 57.0),
                      child: Text('Edit business'),
                    )
                ),
              ),
            if (_isCurrentUserOwner)
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await Costumer.removeHotel(widget.hotel.hotelName);
                      await Favourites.removeBusinessFromAllFavourites(widget.hotel.hotelName);
                      await Hotel.deleteHotel(widget.hotel.hotelName);
                      Navigator.pushNamedAndRemoveUntil(context, '/home/', (route) => false);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('Delete business'),
                    )
                ),
              ),


            Center(
              child: ElevatedButton(
                onPressed: () async {
                  HotelCheckoutDTO hotelCheckoutDTO = await BHService.getHotelCheckoutDTO(
                      widget.hotel.hotelName, hotelEntity: widget.hotel);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelCheckoutScreen(hotel: hotelCheckoutDTO),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
                ),
                child: const Text('BookNow', style: TextStyle(fontSize: 20)),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Rate and review',
              style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: _reviewComment,
                decoration: const InputDecoration(
                  hintText: 'Give us your review...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _numberOfStars = 1;
                        _starOneColor = Colors.black;
                        _starTwoColor = Colors.yellow;
                        _starThreeColor = Colors.yellow;
                        _starFourColor = Colors.yellow;
                        _starFiveColor = Colors.yellow;
                      });
                    },
                    icon: Stack(
                      children: [
                        const Icon(Icons.star, size: 40, color: Colors.black),
                        Icon(Icons.star, size: 36, color: _starOneColor),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _numberOfStars = 2;
                        _starOneColor = Colors.black;
                        _starTwoColor = Colors.black;
                        _starThreeColor = Colors.yellow;
                        _starFourColor = Colors.yellow;
                        _starFiveColor = Colors.yellow;
                      });
                    },
                    icon: Stack(
                      children: [
                        const Icon(Icons.star, size: 40, color: Colors.black),
                        Icon(Icons.star, size: 36, color: _starTwoColor),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _numberOfStars = 3;
                        _starOneColor = Colors.black;
                        _starTwoColor = Colors.black;
                        _starThreeColor = Colors.black;
                        _starFourColor = Colors.yellow;
                        _starFiveColor = Colors.yellow;
                      });
                    },
                    icon: Stack(
                      children: [
                        const Icon(Icons.star, size: 40, color: Colors.black),
                        Icon(Icons.star, size: 36, color: _starThreeColor),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _numberOfStars = 4;
                        _starOneColor = Colors.black;
                        _starTwoColor = Colors.black;
                        _starThreeColor = Colors.black;
                        _starFourColor = Colors.black;
                        _starFiveColor = Colors.yellow;
                      });
                    },
                    icon: Stack(
                      children: [
                        const Icon(Icons.star, size: 40, color: Colors.black),
                        Icon(Icons.star, size: 36, color: _starFourColor),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _numberOfStars = 5;
                        _starOneColor = Colors.black;
                        _starTwoColor = Colors.black;
                        _starThreeColor = Colors.black;
                        _starFourColor = Colors.black;
                        _starFiveColor = Colors.black;
                      });
                    },
                    icon: Stack(
                      children: [
                        const Icon(Icons.star, size: 40, color: Colors.black),
                        Icon(Icons.star, size: 36, color: _starFiveColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String? currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';
                  Costumer? reviewer = await Costumer.findByEmail(currentUserEmail);
                  Hotel updatedHotel = widget.hotel;
                  updatedHotel.reviewsSum += _numberOfStars;
                  updatedHotel.reviewsCounter += 1;
                  updatedHotel.reviewGrade = updatedHotel.reviewsSum / updatedHotel.reviewsCounter;
                  Review review = Review(
                      reviewer!.username,
                      _numberOfStars,
                      _reviewComment.text,
                      DateTime.now()
                  );
                  updatedHotel.reviews.add(review);

                  await Hotel.updateHotel(updatedHotel);

                  _reviewComment.clear();

                  setState(() {
                    _numberOfStars = 0;
                    _starOneColor = Colors.yellow;
                    _starTwoColor = Colors.yellow;
                    _starThreeColor = Colors.yellow;
                    _starFourColor = Colors.yellow;
                    _starFiveColor = Colors.yellow;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                ),
                child: const Text('Submit review', style: TextStyle(fontSize: 16)),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                  'Reviews:',
                  style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold)
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.hotel.reviews.length,
                  itemBuilder: (context, index) {
                    final review = widget.hotel.reviews[index];
                    return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    review.reviewerUsername,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    '${review.date.day}.${review.date.month}.${review.date.year}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                              child: Text(
                                review.comment,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  review.grade.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                const Icon(Icons.star, size: 23, color: Colors.black)
                              ],
                            ),
                          ],
                        )
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
