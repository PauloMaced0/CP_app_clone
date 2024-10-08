import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(CPapp());
}

class CPapp extends StatelessWidget {
  const CPapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cêpê',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIdx) {
      case 0:
        page = SearchPage();
      case 1:
        page = NextTrainPage();
      case 2:
        page = FavoritesPage();
      case 3:
        page = TicketsPage();
      case 4:
        page = ProfilePage();
      default:
        throw UnimplementedError('no widget for $selectedIdx');
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: page),
                SafeArea(
                  child: BottomNavigationBar(
                    showUnselectedLabels: false,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.train_outlined),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.star_outline_outlined),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.receipt_long_outlined),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_2_outlined),
                        label: '',
                      ),
                    ],
                    currentIndex: selectedIdx,
                    onTap: (value) {
                      setState(() {
                        selectedIdx = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.search),
                        label: Text('Search'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.train_outlined),
                        label: Text('Next Train'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite_outline),
                        label: Text('Activity'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.receipt_long_outlined),
                        label: Text('Tickets'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_2_outlined),
                        label: Text('Profile'),
                      ),
                    ],
                    selectedIndex: selectedIdx,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIdx = value;
                      });
                    },
                  ),
                ),
                Expanded(child: page),
              ],
            );
          }
        },
      ),
    );
  }
}

List<Map<String, String>> searchHistory = [];

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DateTime? selectedDateTime = DateTime.now();

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  void _switchValues() {
    setState(() {
      String temp = fromController.text;
      fromController.text = toController.text;
      toController.text = temp;
    });
  }

  void _addToSearchHistory() {
    if (fromController.text.isNotEmpty && toController.text.isNotEmpty) {
      searchHistory.add({
        'from': fromController.text,
        'to': toController.text,
        'date': DateFormat('EEE, dd MMM, HH:mm').format(selectedDateTime!),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/station.jpeg',
                      fit: BoxFit
                          .cover,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Text(
                      'Where do you want to go?',
                      style: TextStyle(
                        color: Colors
                            .white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize
                    .min,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.swap_vert, size: 28),
                        onPressed: _switchValues,
                      ),
                      SizedBox(
                          width:
                              2),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: [
                            _buildTextInput('From', fromController),
                            SizedBox(
                                height:
                                    12),
                            _buildTextInput('To', toController),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  _buildDepartureButton(context),
                  SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (fromController.text != '' ||
                            toController.text != '') {
                          _addToSearchHistory();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrainResultPage(
                                  fromStation: fromController.text,
                                  toStation: toController.text,
                                  selectedDateTime: selectedDateTime!),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 20),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a text input field
  Widget _buildTextInput(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  // Helper function to build the departure button with day info
  Widget _buildDepartureButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            await _pickDateTime(context);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Departure',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  selectedDateTime != null
                      ? DateFormat('EEEE, dd MMMM, HH:mm')
                          .format(selectedDateTime!)
                      : 'Select Date & Time',
                  style: TextStyle(
                      fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> _pickDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
}

class NextTrainPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/train_station.png',
                      fit: BoxFit
                          .cover,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Text(
                      'what\'s the next train',
                      style: TextStyle(
                        color: Colors
                            .white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: _buildTextInput('Chose your station'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a text input field
  Widget _buildTextInput(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

}

class FavoritesPage extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Activity',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.grey[800]
        ), 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(
                'Recent Search',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  final search = searchHistory[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                search['from']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.grey[700],
                                size: 22,
                              ),
                              Text(
                                search['to']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            search['date']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize
            .min,
        children: [
          Text(
            'There are no tickets yet',
            style: TextStyle(fontSize: 24, color: Colors.black54),
          ),
          SizedBox(height: 8),
          Text(
            'Get your tickets online for the quickest service',
            style: TextStyle(
                fontSize: 16,
                color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                AssetImage('assets/avatar.png'), // should be changed to the actual avatar, but works for now
            backgroundColor:
                Colors.grey[200],
          ),
          SizedBox(height: 16),

          Text(
            'John Doe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileOption(
                  'Your Timetables',
                  Icons.schedule,
                  () {
                    print('Your Timetables tapped');
                  },
                ),
                _buildProfileOption(
                  'Settings',
                  Icons.settings,
                  () {
                    print('Settings tapped');
                  },
                ),
                _buildProfileOption(
                  'Contacts',
                  Icons.contacts,
                  () {
                    print('Contacts tapped');
                  },
                ),
                _buildProfileOption(
                  'Discounts and Benefits',
                  Icons.local_offer,
                  () {
                    print('Discounts and Benefits tapped');
                  },
                ),
                _buildProfileOption(
                  'Alerts and Information',
                  Icons.info,
                  () {
                    print('Alerts and Information tapped');
                  },
                ),
                _buildProfileOption(
                  'Traffic Information',
                  Icons.av_timer,
                  () {
                    print('Traffic Information tapped');
                  },
                ),
                _buildProfileOption(
                  'Social Networks',
                  Icons.link_outlined,
                  () {
                    print('Social Networks tapped');
                  },
                ),
                _buildProfileOption(
                  'Terms and Privacy',
                  Icons.privacy_tip,
                  () {
                    print('Terms and Privacy tapped');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, // The action when tapped
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: Colors.grey,
            ), // Icon for the option
            SizedBox(width: 11), // Space between the icon and the text
            Text(
              label,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainResultPage extends StatelessWidget {
  final String fromStation;
  final String toStation;
  final DateTime selectedDateTime;

  TrainResultPage({
    required this.fromStation,
    required this.toStation,
    required this.selectedDateTime,
  });

  final List<Map<String, String>> availableTrains = [
    {
      'kindOfTrain': 'R - Regional',
      'departureTime': '05:30 AM',
      'arrivalTime': '07:00 AM',
      'duration': '1h 30m',
      'price': '20.00',
    },
    {
      'kindOfTrain': 'U - Urban',
      'departureTime': '06:00 AM',
      'arrivalTime': '07:45 AM',
      'duration': '1h 45m',
      'price': '15.00',
    },
    {
      'kindOfTrain': 'IC - Intercidades',
      'departureTime': '06:45 AM',
      'arrivalTime': '09:15 AM',
      'duration': '2h 30m',
      'price': '40.00',
    },
    {
      'kindOfTrain': 'R - Regional',
      'departureTime': '07:00 AM',
      'arrivalTime': '09:00 AM',
      'duration': '2h 00m',
      'price': '18.00',
    },

    {
      'kindOfTrain': 'U - Urban',
      'departureTime': '08:00 AM',
      'arrivalTime': '09:30 AM',
      'duration': '1h 30m',
      'price': '15.00',
    },
    {
      'kindOfTrain': 'R - Regional',
      'departureTime': '08:30 AM',
      'arrivalTime': '10:30 AM',
      'duration': '2h 00m',
      'price': '18.00',
    },
    {
      'kindOfTrain': 'AP - Alfa Pendular',
      'departureTime': '09:00 AM',
      'arrivalTime': '11:30 AM',
      'duration': '2h 30m',
      'price': '60.00',
    },
    {
      'kindOfTrain': 'R - Regional',
      'departureTime': '09:30 AM',
      'arrivalTime': '11:30 AM',
      'duration': '2h 00m',
      'price': '19.00',
    },
    {
      'kindOfTrain': 'U - Urban',
      'departureTime': '10:00 AM',
      'arrivalTime': '11:45 AM',
      'duration': '1h 45m',
      'price': '15.00',
    },

    {
      'kindOfTrain': 'R - Regional',
      'departureTime': '11:00 AM',
      'arrivalTime': '01:00 PM',
      'duration': '2h 00m',
      'price': '17.00',
    },
    {
      'kindOfTrain': 'U - Urban',
      'departureTime': '11:30 AM',
      'arrivalTime': '01:15 PM',
      'duration': '1h 45m',
      'price': '14.00',
    },
    {
      'kindOfTrain': 'AP - Alfa Pendular',
      'departureTime': '12:00 PM',
      'arrivalTime': '02:30 PM',
      'duration': '2h 30m',
      'price': '58.00',
    },
    {
      'kindOfTrain': 'R - Regional',
      'departureTime': '12:30 PM',
      'arrivalTime': '02:30 PM',
      'duration': '2h 00m',
      'price': '18.00',
    },

    {
      'kindOfTrain': 'U - Urban',
      'departureTime': '01:00 PM',
      'arrivalTime': '02:45 PM',
      'duration': '1h 45m',
      'price': '14.00',
    },
    {
      'kindOfTrain': 'R - Regional',
      'departureTime': '01:30 PM',
      'arrivalTime': '03:30 PM',
      'duration': '2h 00m',
      'price': '19.00',
    },
    {
      'kindOfTrain': 'IC - Intercidades',
      'departureTime': '02:00 PM',
      'arrivalTime': '04:30 PM',
      'duration': '2h 30m',
      'price': '42.00',
    },
    {
      'kindOfTrain': 'U - Urban',
      'departureTime': '03:00 PM',
      'arrivalTime': '04:45 PM',
      'duration': '1h 45m',
      'price': '14.00',
    },

    {
      'kindOfTrain': 'R - Regional',
      'departureTime': '05:00 PM',
      'arrivalTime': '07:00 PM',
      'duration': '2h 00m',
      'price': '19.00',
    },
    {
      'kindOfTrain': 'U - Urban',
      'departureTime': '05:30 PM',
      'arrivalTime': '07:15 PM',
      'duration': '1h 45m',
      'price': '15.00',
    },
    {
      'kindOfTrain': 'AP - Alfa Pendular',
      'departureTime': '06:00 PM',
      'arrivalTime': '08:30 PM',
      'duration': '2h 30m',
      'price': '60.00',
    },
    {
      'kindOfTrain': 'R - Regional',
      'departureTime': '07:00 PM',
      'arrivalTime': '09:00 PM',
      'duration': '2h 00m',
      'price': '18.00',
    },
    {
      'kindOfTrain': 'U - Urban',
      'departureTime': '08:00 PM',
      'arrivalTime': '09:45 PM',
      'duration': '1h 45m',
      'price': '14.00',
    },

    {
      'kindOfTrain': 'R - Regional',
      'departureTime': '09:00 PM',
      'arrivalTime': '11:00 PM',
      'duration': '2h 00m',
      'price': '18.00',
    },
    {
      'kindOfTrain': 'U - Urban',
      'departureTime': '10:00 PM',
      'arrivalTime': '11:45 PM',
      'duration': '1h 45m',
      'price': '14.00',
    },
  ];

  List<Map<String, String>> _getFilteredTrains() {
    TimeOfDay selectedTime =
        TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minute);

    List<Map<String, String>> filteredTrains = availableTrains.where((train) {
      TimeOfDay departureTime = _parseTime(train['departureTime']!);
      return _isAfter(departureTime, selectedTime);
    }).toList();

    filteredTrains.sort((a, b) {
      TimeOfDay timeA = _parseTime(a['departureTime']!);
      TimeOfDay timeB = _parseTime(b['departureTime']!);

      if (timeA.hour == timeB.hour) {
        return timeA.minute.compareTo(timeB.minute);
      }
      return timeA.hour.compareTo(timeB.hour);
    });

    return filteredTrains;
  }

  TimeOfDay _parseTime(String timeString) {
    final timeParts = timeString.split(' ');
    final time = timeParts[0].split(':');
    final hour = int.parse(time[0]);
    final minute = int.parse(time[1]);

    // Handle AM/PM
    if (timeParts[1] == 'PM' && hour != 12) {
      return TimeOfDay(hour: hour + 12, minute: minute);
    }
    if (timeParts[1] == 'AM' && hour == 12) {
      return TimeOfDay(hour: 0, minute: minute);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  // Method to check if a train's departure time is after the selected time
  bool _isAfter(TimeOfDay time, TimeOfDay selected) {
    if (time.hour > selected.hour) {
      return true;
    } else if (time.hour == selected.hour) {
      return time.minute > selected.minute;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('E dd MMM, HH:mm').format(selectedDateTime);

    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(
                  height: 6),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'From: ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: fromStation,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[850],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 2),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'To: ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: toStation,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[850],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _getFilteredTrains().length,
                  itemBuilder: (context, index) {
                    final train = _getFilteredTrains()[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              train['kindOfTrain']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Departure',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      train['departureTime']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Arrival',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      train['arrivalTime']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Duration',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      train['duration']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Price:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  '\$${train['price']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}