import 'package:book_now/components/custom_drawer.dart';
import 'package:book_now/model/appointment.dart';
import 'package:book_now/model/business.dart';
import 'package:book_now/model/costumer.dart';
import 'package:book_now/model/exception/business_already_exists_exception.dart';
import 'package:book_now/model/hotel.dart';
import 'package:book_now/model/location.dart';
import 'package:book_now/service/auth_service.dart';
import 'package:book_now/service/image_service.dart';
import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../model/enumerations/business_types.dart';
import '../model/room.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BusinessTypes? _selectedBusinessType;
  bool _isBusinessTypeSelected = false;
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
  final List<Room> _hotelRooms = [];
  late final TextEditingController _roomCapacity;
  late final TextEditingController _numberOfUnits;
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
    _roomCapacity = TextEditingController();
    _numberOfUnits = TextEditingController();
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
    _roomCapacity.dispose();
    _numberOfUnits.dispose();
    super.dispose();
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
                DropdownButton<BusinessTypes>(
                  hint: const Text('Select Business Type'),
                  value: _selectedBusinessType,
                  onChanged: (BusinessTypes? newValue) {
                    setState(() {
                      _selectedBusinessType = newValue;
                      _isBusinessTypeSelected = true;
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  iconEnabledColor: Colors.black,
                  isExpanded: true,
                  items: BusinessTypes.values.map<DropdownMenuItem<BusinessTypes>>((BusinessTypes value) {
                    return DropdownMenuItem<BusinessTypes>(
                      value: value,
                      child: Text(value.printName),
                    );
                  }).toList(),
                ),
                if (_isBusinessTypeSelected)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _businessName,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Business name',
                          labelText: 'Business name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
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
                if (_selectedBusinessType != BusinessTypes.hotel && _isBusinessTypeSelected)
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
                                appointmentSchedule,//TODO tobe implemented
                                {}, //TODO tobe implemented
                                0,
                                0,
                                0,
                                [],
                                _selectedBusinessType!,
                                _website.text,
                                _image);
                            currentCostumer?.addBusiness(_businessName.text);
                            try {
                              await business.saveBusiness();
                              Navigator.pushNamedAndRemoveUntil(context, '/my-businesses/', (route) => false);
                            } on BusinessAlreadyExistException catch (e) {
                              setState(() {
                                errorMessage = e.toString();
                              });
                            }
                          },
                          child: const Text('Create business'),
                        ),
                      ),
                    ],
                  ),
                if (_selectedBusinessType == BusinessTypes.hotel && _isBusinessTypeSelected)
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
                if (_hotelRooms.isNotEmpty && _selectedBusinessType == BusinessTypes.hotel) ...[
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
                                _businessName.text,
                                currentCostumer?.email ?? '',
                                businessLocation,
                                _selectedStartTime,
                                _selectedClosingTime,
                                _hotelRooms,
                                {}, //TODO tobe implemented
                                0,
                                0,
                                0,
                                [],
                                _selectedBusinessType!,
                                _website.text,
                                _image);
                            currentCostumer?.addHotel(_businessName.text);
                            try {
                              await hotel.saveHotel();
                              Navigator.pushNamedAndRemoveUntil(context, '/my-businesses/', (route) => false);
                            } on BusinessAlreadyExistException catch (e) {
                              setState(() {
                                errorMessage = e.toString();
                              });
                            }
                          },
                          child: const Text('Create business'),
                        ),
                      ),
                    ],
                  )
                ],
              ],
            ),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
