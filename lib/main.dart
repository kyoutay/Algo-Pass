import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'App_Page.dart';
import 'settings.dart';
import 'custom_icons.dart';
import 'onboard_screen.dart';

void main() => runApp(new MaterialApp(
  theme:
  ThemeData(primaryColor: Colors.blue, accentColor: Colors.greenAccent),
  debugShowCheckedModeBanner: false,
  routes: {
    '/' : (context) => introState(),
  },
  initialRoute: '/',
));


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String _authorizedOrNot = "Not Authorized";
  static const IconData fingerprint = IconData(0xe90d, fontFamily: 'MaterialIcons');


  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Are you worthy?",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (isAuthorized) {
        _authorizedOrNot = "Authorized";
      } else {
        _authorizedOrNot = "Not Authorized";
      }
    });

    if(isAuthorized){
      Navigator.push(context, new MaterialPageRoute(
        builder: (context) => App_page()
      ));
    }
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
        body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.black),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                                Custom.a_p_logoinvw,
                                color: Colors.greenAccent,
                                size: 150.0,
                              ),
                            Padding(
                              padding: EdgeInsets.only(top: 40.0),
                            ),
                            Text(
                              'アルゴパス',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  ),
                            )
                            ],
                        ),
                      ),
                    ),
                    Expanded(flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          IconButton(
                            icon: Icon(Icons.fingerprint,
                              size: 50,
                              color: Colors.tealAccent,
                            ),
                            onPressed: () {
                              Data.passOn ? Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => App_page())) : _authorizeNow();
                            }
                          ),
                          Padding(
                            padding:EdgeInsets.only(top: 20.0),
                          ),
                        ],
                      ),
                    )
                  ]
              )
            ]
        )
    );
  }
}

