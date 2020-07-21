import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class about extends StatelessWidget {
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('About'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Text('Developed by Kyle Thai',
              style: TextStyle(color: Colors.white),
              ),
              subtitle: Text('working on my plan for world domination, but you can still contact me(tap)',
                style: TextStyle(color: Colors.white30),
              ),
              onTap: (){
                launch('https://www.youtube.com/watch?v=dQw4w9WgXcQ');
              },
            ),
            ListTile(
              title: Text('Version',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text('1.0.0',
                style: TextStyle(color: Colors.white30),
              ),
              onTap:(){},
            ),
          ],
        ).toList(),
      ),
      backgroundColor: Colors.white10,
    );
  }
}
