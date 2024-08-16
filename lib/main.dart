import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var iconsList = [
  {'iconName': Icons.thermostat, 'keyName': 'temp', 'unit': '°C'},
  {'iconName': Icons.wb_cloudy_outlined, 'keyName': 'feels_like', 'unit': '°C'},
  {'iconName': Icons.arrow_downward, 'keyName': 'temp_min', 'unit': '°C'},
  {'iconName': Icons.arrow_upward, 'keyName': 'temp_max', 'unit': '°C'},
  {'iconName': Icons.air, 'keyName': 'pressure', 'unit': 'hPa'},
  {'iconName': Icons.water_drop, 'keyName': 'humidity', 'unit': '%'},
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _cityInput = TextEditingController();
  var inputText = '';

  var fetchedWeatherData = {};

  getWeatherData(var city) async {
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=658a999b38d9253a78b1726906ceebc8");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        fetchedWeatherData = jsonDecode(response.body);
      });
    }
  }

  @override
  void dispose() {
    _cityInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: _cityInput,
                  decoration: const InputDecoration(
                    labelText: 'Enter city name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                getWeatherData(_cityInput.text);
              },
              child: const Text('Enter city name'),
            ),
            if (fetchedWeatherData.isNotEmpty) // Check for data
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: iconsList.map((iconData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          iconData['iconName'] as IconData,
                          color: Colors.yellow.shade900,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${fetchedWeatherData['main']?[iconData['keyName']]?.toString() ?? 'N/A'} ${iconData['unit']}',
                        ),
                      ],
                    );
                  }).toList(), // Convert the iterator to a list
                ),
              ),
          ],
        ),
      ),
    );
  }
}
