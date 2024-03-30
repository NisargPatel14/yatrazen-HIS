import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  final String location;

  const Weather({Key? key, required this.location}) : super(key: key);

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
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    final currentWeatherUrl =
        'http://api.weatherapi.com/v1/current.json?key=4e66b71c66fb48bdb4275305241202&q=${widget.location}';
    final forecastUrl =
        'http://api.weatherapi.com/v1/forecast.json?key=4e66b71c66fb48bdb4275305241202&q=${widget.location}&days=7';

    try {
      final currentWeatherResponse =
          await http.get(Uri.parse(currentWeatherUrl));
      final forecastResponse = await http.get(Uri.parse(forecastUrl));

      if (currentWeatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        final currentWeatherData = jsonDecode(currentWeatherResponse.body);
        final forecastData = jsonDecode(forecastResponse.body);

        setState(() {
          _currentWeather = currentWeatherData['current']['condition']['text'];
          _currentTemp = currentWeatherData['current']['temp_c'].toString();
          _forecast = forecastData['forecast']['forecastday'];
        });
      } else {
        print('Failed to load weather data');
      }
    } catch (e) {
      print('Failed to load weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E1219),
      appBar: AppBar(
        title:const Text(
          "Weather",
          style: TextStyle(
            color:  Color(0xffffffff),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          )
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
                  textAlign: TextAlign.center,
                  widget.location == "Mumbai"
                      ? "Loading..."
                      :
                  "Current weather \nAddress:${widget.location.split(',')[4]}${widget.location.split(',')[5]} \nWeather Type : $_currentWeather, \nTemperature: $_currentTemp°C",
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