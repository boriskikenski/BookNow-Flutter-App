import 'package:book_now/components/custom_drawer.dart';
import 'package:book_now/model/costumer.dart';
import 'package:book_now/model/exception/business_already_exists_exception.dart';
import 'package:book_now/model/location.dart';
import 'package:book_now/screens/hotel_screen.dart';
import 'package:book_now/service/auth_service.dart';
import 'package:book_now/service/image_service.dart';
import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../model/enumerations/business_types.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../model/hotel.dart';
import '../model/room.dart';
import '../service/favourites_service.dart';
class HotelEditScreen extends StatefulWidget {
  final Hotel existingHotel;
  const HotelEditScreen({super.key, required this.existingHotel});

  @override
  State<HotelEditScreen> createState() => _HotelEditScreenState();
}

class _HotelEditScreenState extends State<HotelEditScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BusinessTypes? _selectedBusinessType;
  late final TextEditingController _hotelName;
  late final TextEditingController _website;
  late final TextEditingController _country;
  late final TextEditingController _city;
  late final TextEditingController _street;
  late final TextEditingController _streetNumber;
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  Color _startTimeButtonColor = Colors.white;
  TimeOfDay _selectedClosingTime = TimeOfDay.now();
  Color _closingTimeButtonColor = Colors.white;
  late List<Room> _hotelRooms = [];
  late final TextEditingController _roomCapacity;
  late final TextEditingController _numberOfUnits;
  late final TextEditingController _price;
  String errorMessage = '';
  String _image = '';
  Color _selectImageButtonColor = Colors.white;

  @override
  void initState() {
    _hotelName = TextEditingController();
    _website = TextEditingController();
    _country = TextEditingController();
    _city = TextEditingController();
    _street = TextEditingController();
    _streetNumber = TextEditingController();
    _roomCapacity = TextEditingController();
    _numberOfUnits = TextEditingController();
    _price = TextEditingController();
    _initEditFields();
    super.initState();
  }

  @override
  void dispose() {
    _hotelName.dispose();
    _website.dispose();
    _country.dispose();
    _city.dispose();
    _street.dispose();
    _streetNumber.dispose();
    _roomCapacity.dispose();
    _numberOfUnits.dispose();
    _price.dispose();
    super.dispose();
  }

  void _initEditFields() {
    final hotel = widget.existingHotel;
    _hotelName.text = hotel.hotelName;
    _website.text = hotel.website;
    _country.text = hotel.location.country;
    _city.text = hotel.location.city;
    _street.text = hotel.location.street;
    _streetNumber.text = hotel.location.streetNumber.toString();
    _selectedStartTime = hotel.openingTime;
    _selectedClosingTime = hotel.closingTime;
    _image = hotel.encodedImage;
    _hotelRooms = hotel.rooms;
    _selectedBusinessType = hotel.filter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.yellow,
      appBar: CustomAppBar(
        title: 'Create business',
        leadingOnPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0, left: 40.0, right: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.existingHotel.hotelName,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: _website,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Website',
                          labelText: 'Website',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text('Location:',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: _country,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Country',
                          labelText: 'Country',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: _city,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'City',
                          labelText: 'City',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: _street,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Street',
                          labelText: 'Street',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: _streetNumber,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Street number',
                          labelText: 'Street number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text('Image:',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              _image = ImageService.convertImageToBase64String(File(pickedFile.path));
                            });
                          }
                          _selectImageButtonColor = Colors.yellow;
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(_selectImageButtonColor),
                        ),
                        child: const Text('Select image'),
                      ),
                    ),
                    if (_image.isNotEmpty)
                      Center(
                        child: Image.memory(
                          ImageService.imageFromBase64String(_image),
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text('Working hours:',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedStartTime,
                          );
                          if (picked != null && picked != _selectedStartTime) {
                            setState(() {
                              _selectedStartTime = picked;
                            });
                          }
                          _startTimeButtonColor = Colors.yellow;
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(_startTimeButtonColor),
                        ),
                        child: const Text('Select Opening Time'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedClosingTime,
                          );
                          if (picked != null && picked != _selectedStartTime) {
                            setState(() {
                              _selectedClosingTime = picked;
                            });
                          }
                          _closingTimeButtonColor = Colors.yellow;
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(_closingTimeButtonColor),
                        ),
                        child: const Text('Select Closing Time'),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text('Define Hotel Rooms:',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        controller: _roomCapacity,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'How many beds room has?',
                          labelText: 'How many beds room has?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: _numberOfUnits,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'How many rooms like this are in the hotel?',
                          labelText: 'How many rooms like this are in the hotel?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: _price,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Price per night [\$]',
                          labelText: 'Price per night [\$]',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _hotelRooms.add(Room(
                                int.tryParse(_roomCapacity.text) ?? 0,
                                int.tryParse(_numberOfUnits.text) ?? 0,
                                double.tryParse(_price.text) ?? 0)
                            );

                            _roomCapacity.clear();
                            _numberOfUnits.clear();
                            _price.clear();
                          });
                        },
                        child: const Text('Add room(s)'),
                      ),
                    ),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text('Already defined types of rooms:',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _hotelRooms.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              '${_hotelRooms[index].capacity} Bed -> Number of Units: ${_hotelRooms[index].numberOfUnits}',
                              textAlign: TextAlign.start
                          ),
                        );
                      },
                    ),
                    if(errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Center(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          Costumer? currentCostumer = await AuthService.getCurrentCostumer();
                          Location businessLocation = Location(
                              _country.text,
                              _city.text,
                              _street.text,
                              int.parse(_streetNumber.text));
                          Hotel hotel = Hotel(
                              widget.existingHotel.hotelName,
                              currentCostumer?.email ?? '',
                              businessLocation,
                              _selectedStartTime,
                              _selectedClosingTime,
                              _hotelRooms,
                              {},
                              0,
                              0,
                              0,
                              [],
                              _selectedBusinessType!,
                              _website.text,
                              _image);
                          try {
                            await Hotel.updateHotel(hotel);
                            bool isAlreadyFavourite = await FavouritesService.checkIsFavourite(hotel.hotelName, hotel.filter);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => HotelScreen(
                                        hotel: hotel,
                                        isAlreadyFavourite: isAlreadyFavourite)),
                                    (route) => false
                            );
                          } on BusinessAlreadyExistException catch (e) {
                            setState(() {
                              errorMessage = e.toString();
                            });
                          }
                        },
                        child: const Text('Submit changes'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
