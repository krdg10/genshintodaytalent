import 'package:flutter/material.dart';
import 'package:genshintodaytalent/assets/CharacterItem.dart';
import 'package:genshintodaytalent/assets/Functions.dart';
import 'package:genshintodaytalent/assets/ListGrid.dart';
import 'package:genshintodaytalent/database/dao/character_dao.dart';
import 'package:genshintodaytalent/models/character.dart';
import 'package:genshintodaytalent/screens/listPage.dart';
import 'package:genshintodaytalent/screens/profilePage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CharacterDao _characterDao = CharacterDao();
  String dropdownValue = 'Characters';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('teste'),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('All Characters'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ListPage(type: 'char'),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('All Weapons'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ListPage(type: 'weapon'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: 60, child: Image.asset('images/Logo.png')),
            Container(
              height: 40,
              child: DropdownButton(
                value: dropdownValue,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>[
                  'Characters',
                  'Weapons',
                  'All',
                  'Mine Characters',
                  'Mine Weapons',
                  'All Mine',
                  'Tomorrow Characters',
                  'Tomorrow Weapons'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListGrid(
              listOfCharsOrWeapons: _characterDao.findToday(dropdownValue),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 97,
      ),
    );
  }
}
