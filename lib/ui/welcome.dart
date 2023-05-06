import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/models/constants.dart';
import 'package:weather/ui/home.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    List<String> cities = [
      'Urgench',
      'Khiva',
      'Xonqa',
      'Xiva',
      'Shovot',
      'Tashkent',
      'Bekobod',
      'Chirchiq',
      'Yangiyul',
      'Ohangaron',
      'Parkent',
      'London',
      'Tokyo',
      'Delhi',
      'Beijing',
      'Paris',
      'Rome',
      'Lagos',
      'Amsterdam',
      'Barcelona',
      'Miami',
      'Vienna',
      'Berlin',
      'Toronto',
      'Brussels',
      'Nairobi'
    ];

    Constants constants = Constants();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: constants.secondaryColor,
        title: Text('Cities'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: cities.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                              location: cities[index],
                            )));
              },
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 20, right: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: size.height * .08,
                width: size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: constants.primaryColor.withOpacity(.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cities[index],
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.black54,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> setSity(String city) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("cityName", city);
  }
}
