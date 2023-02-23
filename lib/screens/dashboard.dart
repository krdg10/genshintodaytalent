import 'package:flutter/material.dart';
import 'package:genshintodaytalent/assets/ListGrid.dart';
import 'package:genshintodaytalent/database/dao/character_dao.dart';
import 'package:genshintodaytalent/screens/listPage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CharacterDao _characterDao = CharacterDao();
  String dropdownValue = 'Characters - Today';
  final snackBar = SnackBar(
    content: const Text('Dates According to America Server.'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Genshin Today'),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: AssetImage("images/Wallpaper.jpg"),
                      fit: BoxFit.cover)),
              child: Text('Genshin Today'),
            ),
            ListTile(
              title: const Text(
                'All Characters',
                style: TextStyle(color: Colors.blue),
              ),
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
              title: const Text(
                'All Weapons',
                style: TextStyle(color: Colors.blue),
              ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: 60, child: Image.asset('images/Logo.png')),
            Container(
              height: 40,
              child: DropdownButton(
                value: dropdownValue,
                elevation: 16,
                style: const TextStyle(color: Colors.blue),
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                items: <String>[
                  'Characters - Today',
                  'Weapons - Today',
                  'All - Today',
                  'My Characters - Today',
                  'My Weapons - Today',
                  'My Characters and Weapons - Today',
                  'Characters - Tomorrow',
                  'Weapons - Tomorrow'
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
              height: (MediaQuery.of(context).size.height - 60 - 40 - 2 - 78)
                  .toInt(),
            ),
          ],
        ),
      ),
    );
  }
}
