import 'package:book_now/model/dto/home_screen_dto.dart';
import 'package:book_now/model/dto/business_checkout_dto.dart';
import 'package:book_now/model/dto/hotel_checkout_dto.dart';
import 'package:book_now/screens/business_checkout_screen.dart';
import 'package:book_now/screens/business_screen.dart';
import 'package:book_now/screens/hotel_checkout_screen.dart';
import 'package:book_now/screens/hotel_screen.dart';
import 'package:book_now/service/business_hotel_service.dart';
import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';
import '../model/business.dart';
import '../model/enumerations/business_types.dart';
import '../model/hotel.dart';
import '../service/image_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<HomeScreenDTO>> _businessesAndHotels;
  BusinessTypes? _selectedBusinessType;
  String? _selectedBusinessLocation;
  final Set<String> _businessLocationList = {};
  final List<String> _orderOptions = [
    "Price: Low -> High", "Price: High -> Low",
    "Rating: Low -> High", "Rating: High -> Low"
  ];
  String? _selectedOrderOption;

  @override
  void initState() {
    super.initState();
    _businessesAndHotels = BHService.fetchAllBusinessesAndHotels();
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
      body: Column(
        children: [
          Container(
            color: Colors.amberAccent,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Filter by:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showBusinessTypeDialog(context);
                        },
                        child: const Text('Category'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showBusinessLocationDialog(context);
                        },
                        child: const Text('Location'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showOrderDialog(context);
                        },
                        child: const Text('Order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<HomeScreenDTO>>(
              future: _businessesAndHotels,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  List<HomeScreenDTO> items = snapshot.data!;
                  for (var element in items) {
                    _businessLocationList.add(element.city);
                  }
                  if (_selectedBusinessType != null) {
                    items = items
                        .where((item) => item.filter == _selectedBusinessType)
                        .toList();
                  }
                  if (_selectedBusinessLocation != null) {
                    items = items
                        .where((item) => item.city == _selectedBusinessLocation)
                        .toList();
                  }
                  if(_selectedOrderOption != null && _selectedOrderOption == _orderOptions[0]) {
                    items.sort((a, b) => a.price.compareTo(b.price));
                  }
                  if(_selectedOrderOption != null && _selectedOrderOption == _orderOptions[1]) {
                    items.sort((a, b) => b.price.compareTo(a.price));
                  }
                  if(_selectedOrderOption != null && _selectedOrderOption == _orderOptions[2]) {
                    items.sort((a, b) => a.reviewGrade.compareTo(b.reviewGrade));
                  }
                  if(_selectedOrderOption != null && _selectedOrderOption == _orderOptions[3]) {
                    items.sort((a, b) => b.reviewGrade.compareTo(a.reviewGrade));
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: const Color.fromRGBO(255, 228, 0, 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    items[index].filter.printName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (items[index].reviewGrade > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      '${items[index].reviewGrade} (${items[index].reviewsCounter} reviews)',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                if (items[index].reviewGrade == 0)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      'No ratings',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                            Center(
                              child: Text(
                                items[index].name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: Image.memory(
                                ImageService.imageFromBase64String(items[index].encodedImage),
                                width: 320,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Location: ${items[index].city}, ${items[index].country}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (items[index].filter == BusinessTypes.hotel) {
                                      Hotel? hotel = await Hotel.findByName(items[index].name);
                                      if (hotel != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HotelScreen(hotel: hotel),
                                          ),
                                        );
                                      }
                                    } else {
                                      Business? business = await Business.findByName(items[index].name);
                                      if (business != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BusinessScreen(business: business),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text('More Details'),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (items[index].filter == BusinessTypes.hotel) {
                                      HotelCheckoutDTO hotel = await BHService.getHotelCheckoutDTO(items[index].name);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HotelCheckoutScreen(hotel: hotel),
                                        ),
                                      );
                                    } else {
                                      BusinessCheckoutDTO business = await BHService.getBusinessCheckoutDTO(items[index].name);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BusinessCheckoutScreen(business: business),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('BookNow'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
    );
  }

  void _showBusinessTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ...BusinessTypes.values.map((type) {
                  return ListTile(
                    title: Text(type.printName),
                    onTap: () {
                      setState(() {
                        _selectedBusinessType = type;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
                ListTile(
                  title: const Text(
                    'Remove category filter',
                    style: TextStyle(
                      color: Colors.red
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedBusinessType = null;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBusinessLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Location'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ..._businessLocationList.map((type) {
                  return ListTile(
                    title: Text(type),
                    onTap: () {
                      setState(() {
                        _selectedBusinessLocation = type;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
                ListTile(
                  title: const Text(
                    'Remove location filter',
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedBusinessLocation = null;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order by:'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ..._orderOptions.map((type) {
                  return ListTile(
                    title: Text(type),
                    onTap: () {
                      setState(() {
                        _selectedOrderOption = type;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
                ListTile(
                  title: const Text(
                    'Remove order filter',
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedBusinessLocation = null;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
