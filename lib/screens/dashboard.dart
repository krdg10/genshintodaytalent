import 'package:flutter/material.dart';
import 'package:genshintodaytalent/database/dao/character_dao.dart';
import 'package:genshintodaytalent/models/character.dart';
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
                  'All Mine'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 500,
              child: ListView(scrollDirection: Axis.vertical, children: [
                FutureBuilder(
                  future: _characterDao.findToday(dropdownValue),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        break;
                      case ConnectionState.waiting:
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              Text('Loading'),
                            ],
                          ),
                        );

                      case ConnectionState.active:
                        break;
                      case ConnectionState.done:
                        final List<Character> characters =
                            snapshot.data as List<Character>;

                        if (characters.length == 0) {
                          return Container(
                            child: Text('This category dont have characters'),
                          );
                        } else {
                          return Container(
                            height: 400,
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: characters.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemBuilder: (context, index) {
                                final Character character = characters[index];
                                return _CharacterItem(
                                  character: character,
                                  onClick: () =>
                                      _showCharacterProfile(context, character),
                                );
                              },
                            ),
                          );
                        }
                    }

                    return Text('Unknowm error');
                  },
                )
              ]),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        height: 97,
      ),
    );
  }

  void _showCharacterProfile(BuildContext context, Character character) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfilePage(character: character),
      ),
    );
  }
}

class _CharacterItem extends StatelessWidget {
  final Character character;
  final Function onClick;

  const _CharacterItem({
    Key? key,
    required this.character,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        height: 50,
        child: Column(
          children: [Image.asset(character.photo), Text(character.name)],
        ),
      ),
    );
    /*  return Card(
      child: ListTile(
        title: Text(
          character.name,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: Text(character.talent.period.descriptionDays),
      ),
    );*/

    /*Card(
                    child: new GridTile(
                      //footer: new Text(data[index]),
                      child: new Text(data[index]), //just for testing, will fill with image later
                    ),*/
  }
}
