import 'package:book_now/model/review.dart';
import 'package:book_now/screens/business_checkout_screen.dart';
import 'package:book_now/service/business_hotel_service.dart';
import 'package:book_now/service/website_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';
import '../model/business.dart';
import '../model/dto/business_checkout_dto.dart';
import '../service/image_service.dart';

class BusinessScreen extends StatefulWidget {
  final Business business;

  const BusinessScreen({super.key, required this.business});

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


  @override
  void initState() {
    _reviewComment = TextEditingController();
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                widget.business.businessName,
                style: const TextStyle(fontSize: 28 , fontWeight: FontWeight.bold),
              ),
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
                '${widget.business.openingTime.hour..toString()}:${widget.business.openingTime.minute.toString().toString()} - '
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
                  Business updatedBusiness = widget.business;
                  updatedBusiness.reviewsSum += _numberOfStars;
                  updatedBusiness.reviewsCounter += 1;
                  updatedBusiness.reviewGrade = updatedBusiness.reviewsSum / updatedBusiness.reviewsCounter;
                  Review review = Review(
                      currentUserEmail,
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
          ],
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
