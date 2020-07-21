import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboard_screen.dart';


class Data extends StatefulWidget {

  static bool isVisible = false;
  static bool passOn = false;
  static bool viewGuide = false;

  @override
  _Data createState() => _Data();

}


class _Data extends State<Data>{


  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }

  @override
  void initState() {
    super.initState();
    restore();

  }
  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      Data.isVisible = (sharedPrefs.getBool('show algo') ?? false);
      Data.passOn = (sharedPrefs.getBool('passOn') ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Settings'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            SwitchListTile(
              value: Data.isVisible,
              title: Text("Show Password Algorithm",
                  style: TextStyle(color: Colors.white)),
              onChanged:(bool value) { setState(() { Data.isVisible = value; });
              save('show algo', value);
              },
              subtitle: Text('Like this',
              style: TextStyle(color: Colors.white30)),
            ),
            SwitchListTile(
              value: Data.passOn,
              title: Text("Disable Fingerprint",
                  style: TextStyle(color: Colors.white)),
              onChanged:(bool value) { setState(() { Data.passOn = value; });
              save('passOn', value);
              },
              subtitle: Text('Kinda works',
                  style: TextStyle(color: Colors.white30)),
            ),
            ListTile(
              title: Text('View Guide',
              style: TextStyle(color: Colors.white),),
              trailing: IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                    size: 22.5,
                  ),
                  onPressed: () {
                    Data.viewGuide = true;
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => introState()
                    ));
                  }
              ),
              onTap: (){
                Data.viewGuide = true;
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => introState()
                ));
              },
            ),
          ],
        ).toList(),
      ),
      backgroundColor: Colors.white10,
    );
  }
}




