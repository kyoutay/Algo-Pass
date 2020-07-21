import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'settings.dart';


class introState extends StatefulWidget{
  @override
  _introState createState() => new _introState();
}


class _introState extends State<introState>{

  List<Slide> slides = new List();
  bool yn = false;

  @override
  void initState() {
    super.initState();
    restore();
    slides.add(
      new Slide(
        title: "what?",
        styleTitle:
        TextStyle(color: Colors.white, fontSize: 30.0, fontFamily: 'Courier'),
        description: "Configure an algorithm that will create your passwords",
        styleDescription:
        TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Courier'),
        pathImage: "assets/config_algo.png",
        backgroundColor: Colors.black,
      ),
    );
    slides.add(
      new Slide(
        title: "epic",
        styleTitle:
        TextStyle(color: Colors.white, fontSize: 30.0, fontFamily: 'Courier'),
        description: "Fully customize how your algorithm will create your password",
        styleDescription:
        TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Courier'),
        pathImage: "assets/further_config_algo.png",
        backgroundColor: Colors.black,
      ),
    );
    slides.add(
      new Slide(
        title: "what is it for?",
        styleTitle:
        TextStyle(color: Colors.white, fontSize: 30.0, fontFamily: 'Courier'),
        description:
        "Enter the name of the service that the password will be used for, or enter anything that you want",
        styleDescription:
        TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Courier'),
        pathImage: "assets/name_algo.png",
        backgroundColor: Colors.black,
      ),
    );
    slides.add(
      new Slide(
        title: "your memory is the safest place",
        styleTitle:
        TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'Courier'),
        description:
        "Show or hide the algorithm for a password, so that you can remember it.",
        styleDescription:
        TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Courier'),
        pathImage: "assets/remeber_algo.png",
        backgroundColor: Colors.black,
      ),
    );
    slides.add(
      new Slide(
        title: "super-super-super safe",
        styleTitle:
        TextStyle(color: Colors.white, fontSize: 24.0, fontFamily: 'Courier'),
        description:
        "Encrypted with military-grade AES-256 bit encryption and stored locally. Your data isn't going anywhere.",
        styleDescription:
        TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Courier'),
        pathImage: "assets/security.png",
        backgroundColor: Colors.black,
      ),
    );
  }

  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    }
  }


  Future restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      yn = (sharedPrefs.getBool('yn') ?? false);
    });
    if (yn && Data.viewGuide == false){
      Navigator.pushReplacement(context, new MaterialPageRoute(
          builder: (context) => SplashScreen()
      ));
    }else{
      await sharedPrefs.setBool('yn', true);
    }
    return yn;
  }


  void onDonePress() {
    if(yn) {
      Navigator.of(context).pop();
    }else{
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => SplashScreen()
      ));
    }
  }

  void onSkipPress() {
    if(yn) {
      Navigator.of(context).pop();
    }else{
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => SplashScreen()
      ));
    }
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.greenAccent,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.greenAccent,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.greenAccent,
    );
  }


  @override
Widget build(BuildContext context) {
    if (yn && Data.viewGuide == false){
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.green,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.greenAccent),

          ),
        ),
      );
    }else {
      return IntroSlider(
        // List slides
        slides: this.slides,

        // Skip button
        renderSkipBtn: this.renderSkipBtn(),
        onSkipPress: this.onSkipPress,
        highlightColorSkipBtn: Color(0xff000000),

        // Next, Done button
        onDonePress: this.onDonePress,
        renderNextBtn: this.renderNextBtn(),
        renderDoneBtn: this.renderDoneBtn(),
        highlightColorDoneBtn: Color(0xff000000),

        // Dot indicator
        colorDot: Colors.white10,
        colorActiveDot: Colors.greenAccent,
        sizeDot: 8.0,
      );
    }
  }
}



