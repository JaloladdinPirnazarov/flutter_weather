import 'package:flutter/material.dart';
import 'package:weather/models/constants.dart';
import 'package:weather/UI/welcome.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants constants = Constants();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Weather"),
      //   centerTitle: true,
      // ),

      body: Container(
        width: size.width,
        height: size.height,
        color: constants.primaryColor.withOpacity(.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/get_started.png'),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: (){ Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Welcome())); },
              child: Container(
                height: 50,
                width: size.width * 0.7,
                decoration: BoxDecoration(
                    color: constants.primaryColor,
                    borderRadius:  BorderRadius.all(Radius.circular(10))
                ),
                child: Center(
                  child: Text('Get started', style: TextStyle(color: Colors.white, fontSize: 18,),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
