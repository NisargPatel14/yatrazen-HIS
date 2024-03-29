import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  final String location;

  const Weather({super.key, required this.location});

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String _currentWeather = '';
  String _currentTemp = '';
  List<dynamic> _forecast = [];

  @override
  void initState() {
    super.initState();
    _fetchWeatherData(widget.location);
  }

  Future<void> _fetchWeatherData(String location) async {
    // Fetch current weather
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E1219),
      appBar: AppBar(
        title: Text(
          "Weather",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        backgroundColor: const Color(0xff0E1219),
        iconTheme: const IconThemeData(color: Color(0xffffffff)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _forecast.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Center(
                child: Text(
                  "Current weather in ${widget.location}: $_currentWeather, Temperature: $_currentTemp°C",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff)),
                ),
              );
            } else {
              final dayForecast = _forecast[index - 1];
              return ListTile(
                title: Text(
                  "Day $index: ${dayForecast['day']['condition']['text']}, Average Temperature: ${dayForecast['day']['avgtemp_c']}°C",
                  style: const TextStyle(color: Color(0xffffffff)),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
