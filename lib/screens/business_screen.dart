import 'package:book_now/model/costumer.dart';
import 'package:book_now/model/favourites.dart';
import 'package:book_now/model/review.dart';
import 'package:book_now/screens/business_checkout_screen.dart';
import 'package:book_now/screens/qr_code_scanner.dart';
import 'package:book_now/service/business_hotel_service.dart';
import 'package:book_now/service/website_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';
import '../model/business.dart';
import '../model/dto/business_checkout_dto.dart';
import '../service/image_service.dart';
import 'business_edit_screen.dart';

class BusinessScreen extends StatefulWidget {
  final Business business;
  final bool isAlreadyFavourite;

  const BusinessScreen({super.key, required this.business, required this.isAlreadyFavourite});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
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
    if (widget.business.ownerEmail == currentUserEmail) {
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
                          builder: (context) => QRScanScreen(scanForBusiness: widget.business.businessName),
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
                    widget.business.businessName,
                    style: const TextStyle(fontSize: 28 , fontWeight: FontWeight.bold),
                  ),
                ),
                if (_isFavourite)
                  ElevatedButton(
                    onPressed: () {
                      Favourites.deleteFavourite(widget.business.businessName, widget.business.filter);
                      setState(() {
                        _isFavourite = !_isFavourite;
                      });
                    },
                    child: const Text('Remove from FAV'),
                  ),
                if (!_isFavourite)
                  ElevatedButton(
                    onPressed: () {
                      Favourites.saveFavourite(widget.business.businessName, widget.business.filter);
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
                ImageService.imageFromBase64String(widget.business.encodedImage),
                width: 365,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            const Text(
              'Price per appointment:',
              style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                '${widget.business.appointment.pricePerAppointment.toString()} \$',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            const Text(
              'Website:',
              style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: GestureDetector(
                onTap: () async {
                  await WebsiteService.launchWebsite(context, Uri.parse(widget.business.website));
                },
                child: Text(
                  widget.business.website,
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
                '${widget.business.openingTime.hour.toString()}:${widget.business.openingTime.minute.toString()} - '
                    '${widget.business.closingTime.hour.toString()}:${widget.business.closingTime.minute.toString()}',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            const Text(
              'Location:',
              style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),
            ),
            Text(
              'country: ${widget.business.location.country} ',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'city: ${widget.business.location.city} ',
              style: const TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                'street: ${widget.business.location.street} ${widget.business.location.streetNumber}',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            const Text(
              'Appointment details:',
              style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),
            ),
            Text(
              'people per appointment: ${widget.business.appointment.peoplePerSlot} ',
              style: const TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                'minutes per appointment: ${widget.business.appointment.minPerSlot}',
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
                          builder: (context) => BusinessEditScreen(existingBusiness: widget.business),
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
                      await Costumer.removeBusiness(widget.business.businessName);
                      await Favourites.removeBusinessFromAllFavourites(widget.business.businessName);
                      await Business.deleteBusiness(widget.business.businessName);
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
                  BusinessCheckoutDTO businessCheckoutDTO = await BHService.getBusinessCheckoutDTO(
                      widget.business.businessName, businessEntity: widget.business);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusinessCheckoutScreen(business: businessCheckoutDTO),
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
                  Business updatedBusiness = widget.business;
                  updatedBusiness.reviewsSum += _numberOfStars;
                  updatedBusiness.reviewsCounter += 1;
                  updatedBusiness.reviewGrade = updatedBusiness.reviewsSum / updatedBusiness.reviewsCounter;
                  Review review = Review(
                      reviewer!.username,
                      _numberOfStars,
                      _reviewComment.text,
                      DateTime.now()
                  );
                  updatedBusiness.reviews.add(review);

                  await Business.updateBusiness(updatedBusiness);

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
                  itemCount: widget.business.reviews.length,
                  itemBuilder: (context, index) {
                    final review = widget.business.reviews[index];
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
