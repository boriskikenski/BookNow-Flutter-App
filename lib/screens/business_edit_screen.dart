import 'package:book_now/components/custom_drawer.dart';
import 'package:book_now/model/appointment.dart';
import 'package:book_now/model/business.dart';
import 'package:book_now/model/costumer.dart';
import 'package:book_now/model/exception/business_already_exists_exception.dart';
import 'package:book_now/model/location.dart';
import 'package:book_now/screens/business_screen.dart';
import 'package:book_now/service/auth_service.dart';
import 'package:book_now/service/favourites_service.dart';
import 'package:book_now/service/image_service.dart';
import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../model/enumerations/business_types.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BusinessEditScreen extends StatefulWidget {
  final Business existingBusiness;
  const BusinessEditScreen({super.key, required this.existingBusiness});

  @override
  State<BusinessEditScreen> createState() => _BusinessEditScreenState();
}

class _BusinessEditScreenState extends State<BusinessEditScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BusinessTypes? _selectedBusinessType;
  late final TextEditingController _businessName;
  late final TextEditingController _website;
  late final TextEditingController _country;
  late final TextEditingController _city;
  late final TextEditingController _street;
  late final TextEditingController _streetNumber;
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  Color _startTimeButtonColor = Colors.white;
  TimeOfDay _selectedClosingTime = TimeOfDay.now();
  Color _closingTimeButtonColor = Colors.white;
  late final TextEditingController _minPerAppointment;
  late final TextEditingController _peoplePerAppointment;
  late final TextEditingController _slotsPerStartingTime;
  late final TextEditingController _price;
  String errorMessage = '';
  String _image = '';
  Color _selectImageButtonColor = Colors.white;

  @override
  void initState() {
    _businessName = TextEditingController();
    _website = TextEditingController();
    _country = TextEditingController();
    _city = TextEditingController();
    _street = TextEditingController();
    _streetNumber = TextEditingController();
    _minPerAppointment = TextEditingController();
    _peoplePerAppointment = TextEditingController();
    _slotsPerStartingTime = TextEditingController();
    _price = TextEditingController();
    _initEditFields();
    super.initState();
  }

  @override
  void dispose() {
    _businessName.dispose();
    _website.dispose();
    _country.dispose();
    _city.dispose();
    _street.dispose();
    _streetNumber.dispose();
    _minPerAppointment.dispose();
    _peoplePerAppointment.dispose();
    _slotsPerStartingTime.dispose();
    _price.dispose();
    super.dispose();
  }

  void _initEditFields() {
    final business = widget.existingBusiness;
    _businessName.text = business.businessName;
    _website.text = business.website;
    _country.text = business.location.country;
    _city.text = business.location.city;
    _street.text = business.location.street;
    _streetNumber.text = business.location.streetNumber.toString();
    _selectedStartTime = business.openingTime;
    _selectedClosingTime = business.closingTime;
    _minPerAppointment.text = business.appointment.minPerSlot.toString();
    _peoplePerAppointment.text = business.appointment.peoplePerSlot.toString();
    _slotsPerStartingTime.text = business.appointment.numberOfSlots.toString();
    _price.text = business.appointment.pricePerAppointment.toString();
    _image = business.encodedImage;
    _selectedBusinessType = business.filter;
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
                      widget.existingBusiness.businessName,
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
                  ],),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text('Define appointment schedule:',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: _minPerAppointment,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'How long is one appointment [min]',
                          labelText: 'How long is one appointment [min]',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: _peoplePerAppointment,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'How many people can be served at one appointment',
                          labelText: 'How many people can be served at one appointment',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: _slotsPerStartingTime,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'How many appointments can be opened at one time',
                          labelText: 'How many appointments can be opened at one time',
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
                          hintText: 'Price per appointment [\$]',
                          labelText: 'Price per appointment [\$]',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
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
                          Appointment appointmentSchedule = Appointment(
                            int.tryParse(_minPerAppointment.text) ?? 0,
                            int.tryParse(_peoplePerAppointment.text) ?? 0,
                            int.tryParse(_slotsPerStartingTime.text) ?? 0,
                            double.tryParse(_price.text) ?? 0,
                          );
                          Location businessLocation = Location(
                              _country.text,
                              _city.text,
                              _street.text,
                              int.parse(_streetNumber.text));
                          Business business = Business(
                              _businessName.text,
                              currentCostumer?.email ?? '',
                              businessLocation,
                              _selectedStartTime,
                              _selectedClosingTime,
                              appointmentSchedule,
                              {},
                              0,
                              0,
                              0,
                              [],
                              _selectedBusinessType!,
                              _website.text,
                              _image);
                          try {
                            await Business.updateBusiness(business);
                            bool isAlreadyFavourite = await FavouritesService.checkIsFavourite(business.businessName, business.filter);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => BusinessScreen(
                                        business: business,
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
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
