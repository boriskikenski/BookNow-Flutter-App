import 'package:book_now/components/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../model/enumerations/business_types.dart';
import '../model/room.dart';

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
  List<Room> hotelRooms = [];
  late final TextEditingController _roomCapacity;
  late final TextEditingController _numberOfUnits;

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
            padding: const EdgeInsets.only(top: 70.0, left: 40.0, right: 40.0), // Adjust horizontal padding
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
                            hintText: 'How long is one appointment',
                            labelText: 'How long is one appointment',
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
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              int roomCapacity = int.tryParse(_roomCapacity.text) ?? 0;
                              int numberOfUnits = int.tryParse(_numberOfUnits.text) ?? 0;
                              hotelRooms.add(Room(roomCapacity, numberOfUnits, numberOfUnits));

                              _roomCapacity.clear();
                              _numberOfUnits.clear();
                            });
                          },
                          child: const Text('Add room(s)'),
                        ),
                      ),
                    ],
                  ),
                if (hotelRooms.isNotEmpty && _selectedBusinessType == BusinessTypes.hotel) ...[
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
                        itemCount: hotelRooms.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              '${hotelRooms[index].capacity} Bed -> Number of Units: ${hotelRooms[index].numberOfUnits}',
                              textAlign: TextAlign.start
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      //TODO
                    },
                    child: const Text('Create business'),
                  ),
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
