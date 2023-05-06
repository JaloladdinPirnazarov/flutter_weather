import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather/models/constants.dart';
import 'package:weather/models/weather_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather/ui/welcome.dart';

//var location = "";

class Home extends StatefulWidget {
  final String location;
  Home({required this.location});
  @override
  State<Home> createState() => _HomeState(location: location);
}

class _HomeState extends State<Home> {
  final String location;
  _HomeState({required this.location});
  Constants constants = Constants();
  late WeatherData weatherData;
  String appID = "dbc3efb850cb3ed4c78e7e453899781e&units";
  String updatedAt = "0:00";
  String temp = "0";
  String desc = "Loading..";
  String sunrise = "0:00";
  String sunset = "0:00";
  String windSpeed = "0";
  String pressure = "0";
  String humidity = "0";
  String min = "0";
  String max = "0";

  void showAlert(
      BuildContext context, IconData icon, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                icon,
                color: Colors.red,
              ),
              SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  fetchLocation();
                  Navigator.of(context).pop();
                },
                child: Text("retry")),
            TextButton(
              child: Text('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void fetchLocation() async {
    try {
      var url =
          "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$appID=metric";
      var searchResult = await http.get(Uri.parse(url));
      parseJson(searchResult);
    } catch (e) {
      print("Произошла ошибка: $e\n\n ");
      showAlert(
          context, Icons.error, "Error", "$e\n\nCheck internet connection");
    }
  }

  void parseJson(http.Response searchResult) {
    var jsonData = json.decode(searchResult.body);
    weatherData = WeatherData.fromRawJson(searchResult.body);
    setState(() {
      updatedAt = DateFormat("dd.MM.yyyy hh:mm a", "en_US")
          .format(DateTime.fromMillisecondsSinceEpoch(weatherData.dt * 1000));
      desc = "${weatherData.weather[0].description}";
      temp = weatherData.main.temp.toString();
      sunrise = DateFormat('hh:mm a', 'en_US').format(
          DateTime.fromMillisecondsSinceEpoch(weatherData.sys.sunrise * 1000));
      sunset = DateFormat('hh:mm a', 'en_US').format(
          DateTime.fromMillisecondsSinceEpoch(weatherData.sys.sunset * 1000));
      windSpeed = weatherData.wind.speed.toString();
      pressure = weatherData.main.pressure.toString();
      humidity = weatherData.main.humidity.toString();
      min = weatherData.main.tempMin.toString();
      max = weatherData.main.tempMax.toString();
    });
  }

  @override
  void initState() {
    fetchLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: constants.primaryColor,
      appBar: AppBar(
        title: Text('Weather'),
        actions: [
          IconButton(
              onPressed: () {
                var route = MaterialPageRoute(builder: (context)=> Welcome());
                Navigator.pushReplacement(context, route);
              },
              icon: Icon(
                Icons.location_on_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildTitles(),
            buildTemperature(),
            buildDetails(),
            //_forecast(),
          ],
        ),
      ),
    );
  }

  Widget buildTitles() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              location,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Updated at $updatedAt",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        )
      ],
    );
  }

  Widget buildTemperature() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$temp°C",
            style: TextStyle(color: Colors.white, fontSize: 50),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          )
        ],
      )
    ]);
  }

  Widget buildDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_sunrise(), _sunset(), _wind()],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_pressure(), _humidity(), _info()],
        ),
      ],
    );
  }

  Widget _sunrise() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          'assets/sunrise.png',
          color: Colors.white,
          width: 50,
          height: 50,
        ),
        Text(
          'Sunrise',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          sunrise,
          style: TextStyle(color: Colors.white, fontSize: 15),
        )
      ],
    );
  }

  Widget _sunset() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          'assets/sunset.png',
          color: Colors.white,
          width: 50,
          height: 50,
        ),
        Text(
          'Sunset',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          sunset,
          style: TextStyle(color: Colors.white, fontSize: 15),
        )
      ],
    );
  }

  Widget _wind() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          'assets/wind.png',
          color: Colors.white,
          width: 50,
          height: 50,
        ),
        Text(
          'Wind',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          windSpeed,
          style: TextStyle(color: Colors.white, fontSize: 15),
        )
      ],
    );
  }

  Widget _pressure() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          'assets/pressure.png',
          color: Colors.white,
          width: 50,
          height: 50,
        ),
        Text(
          'Pressure',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          pressure,
          style: TextStyle(color: Colors.white, fontSize: 15),
        )
      ],
    );
  }

  Widget _humidity() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          'assets/humidity.png',
          color: Colors.white,
          width: 50,
          height: 50,
        ),
        Text(
          'Humidity',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          humidity,
          style: TextStyle(color: Colors.white, fontSize: 15),
        )
      ],
    );
  }

  Widget _info() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          'assets/info.png',
          color: Colors.white,
          width: 50,
          height: 50,
        ),
        Text(
          'Created by',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          'Jaloladdin',
          style: TextStyle(color: Colors.white, fontSize: 15),
        )
      ],
    );
  }

  Widget _forecast() {
    final List<String> weekDays = [
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final List<String> monthDays = ['2', '3', '4', '5', '6', '7'];
    final List<String> temperature = ['33', '28', '23', '21', '24', '27'];
    final List<IconData> icons = [
      Icons.sunny,
      Icons.sunny,
      Icons.cloud,
      Icons.cloud,
      Icons.cloud,
      Icons.sunny
    ];
    return SizedBox(
      height: 105.0,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: weekDays.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(6),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff9ebbfa),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      '${weekDays[index]}',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      '${monthDays[index]} may',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '${temperature[index]} °С',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          icons[index],
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
