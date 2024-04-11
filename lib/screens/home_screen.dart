import 'package:book_now/model/dto/home_screen_dto.dart';
import 'package:book_now/service/business_hotel_service.dart';
import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';
import '../model/enumerations/business_types.dart';
import '../service/image_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<HomeScreenDTO>> _businessesAndHotels;

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
      body: FutureBuilder<List<HomeScreenDTO>>(
        future: _businessesAndHotels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final List<HomeScreenDTO> items = snapshot.data!;
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
                                  fontWeight:
                                  FontWeight.bold),
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
                              fontWeight: FontWeight.bold),
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
                            onPressed: () {
                              // TODO tobe implemented
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
                            onPressed: () {
                              // TODO tobe implemented
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
      drawer: const CustomDrawer(),
    );
  }
}
