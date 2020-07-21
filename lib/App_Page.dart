import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'dart:async';
import 'about.dart';
import 'settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Constants{
  static const String settings = 'Settings';
  static const String about = 'About';

  static const List<String> choices = <String>[
    settings,
    about,
  ];
}


class App_page extends StatefulWidget{
  @override
  App_PageState createState() => App_PageState();

}


enum Answers{a, e, i, o, l, custom}

class App_PageState extends State<App_page> {


  TextEditingController _editMaFieldController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();

  final _storage = FlutterSecureStorage();
  List<String> warriors = [];
  bool setter = false;
  String l = '1';
  String e = '3';
  String o = '0';
  String a = '@';
  String i = '!';
  String custom = '(-)+*^*=#4!';
  String eNguyen = '';
  int yellow;
  int idTrack = 0;
  bool SP = false;
  bool SL = false;
  List<String> selectedEditList = List();
  List <String> passes = [];
  List<String> sAlgo = [];
  List <_SecItem> hPass = [];
  bool insert = false;
  bool replace = false;
  int _index;
  String _hPass = '';
  List<String> editFields = [
    'Special Character look-alike',
    'Number look-alike',
    'Reverse Order',
    'Custom',
    'Nothing',
  ];



  @override
  void initState() {
    super.initState();
    restore();
    _readAll();
  }


  Future<Null> _readAll() async {
    final all = await _storage.readAll();
    setState(() {
      return hPass = all.keys
          .map((key) => _SecItem(key, all[key]))
          .toList(growable: false);
    });
  }


  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      SP = (sharedPrefs.getBool('SP') ?? false);
      SL = (sharedPrefs.getBool('SL') ?? false);
      idTrack = (sharedPrefs.getInt('idTrack') ?? 0);
    });
    if(SP) {
      setState(() {
        a = (sharedPrefs.getString('a'));
        e = (sharedPrefs.getString('e'));
        i = (sharedPrefs.getString('i'));
        o = (sharedPrefs.getString('o'));
        l = (sharedPrefs.getString('l'));
        custom = (sharedPrefs.getString('custom'));
        //passes = (sharedPrefs.getStringList('passes'));
      });
    }
    if(SL){
      setState(() {
        passes = (sharedPrefs.getStringList('passes'));
        sAlgo = (sharedPrefs.getStringList('sAlgo'));
      });
      print(passes);
    }
  }


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


  void topokki(){
    for (var i = 0; i < hPass.length; i++){
      warriors.add(hPass[i].value);
    }
    warriors.sort();
  }


  void addBox() async{
    makeAlgo();
    final String key = _hPass;
    final String value = _hPass;
    if (selectedEditList.isEmpty){
      pickUrAlgo();
    }else if (replace){
      setState(() {
        passes.removeAt(_index);
        sAlgo.removeAt(_index);
        passes.insert(_index, _textFieldController.text);
        sAlgo.insert(_index, selectedEditList.join(','));
      });
      replace = false;
    }else if (_textFieldController.text != '' && insert != true) {
      setState(() {
        passes.add(_textFieldController.text);
        sAlgo.add(selectedEditList.join(','));
      });
      await _storage.write(key: key, value: idTrack.toString().padLeft(2, '0') + value);
      _readAll();
      idTrack += 1;
    }
    SL = true;
    save('SL', SL);
    save('passes', passes);
    save('sAlgo', sAlgo);
    save('idTrack', idTrack);
  }


  void makeAlgo() async{
    _hPass = _textFieldController.text;
    if(selectedEditList.contains('Special Character look-alike')){
      _hPass = '${_hPass.toLowerCase().replaceAll('a', '$a').replaceAll('i', '$i')}';
    }
    if(selectedEditList.contains('Number look-alike')){
      _hPass = '${_hPass.toLowerCase().replaceAll('e', '$e').replaceAll('o', '$o').replaceAll('l', '$l')}';
    }
    if(selectedEditList.contains('Reverse Order')){
      _hPass = _hPass.split('').reversed.join('');
    }
    if(selectedEditList.contains('Custom')){
      _hPass = _hPass + '$custom';
    }
    if(selectedEditList.contains('Nothing')){}
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter title for password'),
            content: TextField(
              autofocus: true,
              controller: _textFieldController,
              decoration: InputDecoration(labelText: 'Password Name', hintText: "Type something... hurry"),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('COMPLETE'),
                onPressed: () {
                  Navigator.of(context).pop();
                  addBox();
                },
              )
            ],
          );
        });
  }

  _editDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              autofocus: true,
              controller: _editMaFieldController,
              decoration: InputDecoration(hintText: "Replace for $eNguyen"),
              maxLength: 5,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('SAVE'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setter = true;
                },
              )
            ],
          );
        });
  }

  _showEditDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {

          return AlertDialog(
            title: Text("Configure Your Algorithm"),
            content: MultiSelectChip(
              editFields,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedEditList = selectedList;
                });
              },
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('VIEW'),
                onPressed: (){
                  Navigator.of(context).pop();
                  _askUser();
                },
              ),
              FlatButton(
                  child: Text("COMPLETE"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    print(selectedEditList);
                    makeAlgo();
                  }
              ),
            ],
          );
        });
  }

  pickUrAlgo(){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Configure your Algorithm first'),
            content: Text(
                'Press on the edit icon'
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }


  Future editMa() async{
    await _editDialog(context);
    {
      if(yellow == 0){
        setState(() {
          a = _editMaFieldController.text;
        });
      }else if(yellow == 1){
        setState(() {
          e = _editMaFieldController.text;
        });
      }else if(yellow == 2){
        setState(() {
          i = _editMaFieldController.text;
        });
      }else if(yellow == 3){
        setState(() {
          o = _editMaFieldController.text;
        });
      }else if(yellow == 4){
        setState(() {
          l = _editMaFieldController.text;
        });
      }else if(yellow == 5){
        setState(() {
          custom = _editMaFieldController.text;
        });
      }
      _editMaFieldController.text = '';
    }
    if(setter){
      _askUser();
    }
    SP = true;
    save('SP', SP);
    save('a', a);
    save('e', e);
    save('i', i);
    save('o', o);
    save('l', l);
    save('custom', custom);
  }





  Future _askUser() async {
    switch(
    await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Edit?"),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text('a = $a'),
              onPressed: (){
                Navigator.pop(context, Answers.a);
              },
            ),
            new SimpleDialogOption(
              child: new Text("e = $e"),
              onPressed: (){
                Navigator.pop(context, Answers.e);
              },
            ),
            new SimpleDialogOption(
              child: new Text("i = $i"),
              onPressed: (){
                Navigator.pop(context, Answers.i);
              },
            ),
            new SimpleDialogOption(
              child: new Text("o = $o"),
              onPressed: (){
                Navigator.pop(context, Answers.o);
              },
            ),
            new SimpleDialogOption(
              child: new Text("l = $l"),
              onPressed: (){
                Navigator.pop(context, Answers.l);
              },
            ),
            new SimpleDialogOption(
              child: new Text("Custom = $custom"),
              onPressed: (){
                Navigator.pop(context, Answers.custom);
              },
            ),
            FlatButton(
              child: Text('BACK'),
              onPressed: (){
                Navigator.of(context).pop();
                _showEditDialog();
              },
            )
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
        )
    )
    ) {
      case Answers.a:
        yellow = 0;
        editMa();
        eNguyen = 'a';
        break;
      case Answers.e:
        yellow = 1;
        editMa();
        eNguyen = 'e';
        break;
      case Answers.i:
        yellow = 2;
        editMa();
        eNguyen = 'i';
        break;
      case Answers.o:
        yellow = 3;
        editMa();
        eNguyen = 'o';
        break;
      case Answers.l:
        yellow = 4;
        editMa();
        eNguyen = 'l';
        break;
      case Answers.custom:
        yellow = 5;
        editMa();
        eNguyen = 'Custom';
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
    void choiceAction(String choice) {
      if (choice == Constants.about) {
        {
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => about()
          ));
        }
      }
      if (choice == Constants.settings) {
        {
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => Data()
          ));
        }
      }
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ロッカー'),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed:(){
              _displayDialog(context);
              _textFieldController.text = '';
              insert = false;
            },
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              _showEditDialog();
            },
          ),
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: passes.length,
        itemBuilder: (context, index){
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title:Text(passes[index],
              style: TextStyle(color: Colors.white),
              ),
              subtitle: Data.isVisible ? Text(sAlgo[index], style: TextStyle(color: Colors.white30),) : null,
              trailing: IconButton(
                icon: Icon(
                  Icons.content_copy,
                  color: Colors.white30,
                  size: 22.5,
                ),
                  onPressed: () {
                  topokki();
                  print(warriors);
                    ClipboardManager.copyToClipBoard(warriors[index].substring(2)).then((result){
                      final snackBar = SnackBar(
                        content: Text("Password Copied to Clipboard"),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed:(){}
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    });
                    warriors = [];
                  }
              ),
              onTap:(){
                _displayDialog(context);
                insert = true;
                _index = index + 1;
              },
              onLongPress:() {
                topokki();
                replace = true;
                //_displayDialog(context);
                _index = index;
                _performAction(warriors[index]);
                warriors = [];
              },
            ),
            color: Colors.white10,
          );
        },
      )
    );
  }

  Future<Null> _performAction(String item) async {
    await _displayDialog(context);
    _storage.write(key: item.substring(2), value: _index.toString().padLeft(2, '0') + _hPass);
    _readAll();
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> editFields;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.editFields, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.editFields.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

class _SecItem {
  _SecItem(this.key, this.value);

  final String key;
  final String value;
}



