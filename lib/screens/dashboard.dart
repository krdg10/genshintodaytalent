import 'package:flutter/material.dart';
import 'package:genshintodaytalent/database/dao/character_dao.dart';
import 'package:genshintodaytalent/models/character.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CharacterDao _characterDao = CharacterDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('teste'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/Logo.png'),
          Container(
            height: 120,
            child: ListView(scrollDirection: Axis.vertical, children: [
              FutureBuilder(
                future: _characterDao.findAll(),
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
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final Character character = characters[index];
                          return _CharacterItem(character);
                        },
                        itemCount: characters.length,
                      );
                  }
                  return Text('Unknowm error');
                },
              )
            ]),
          )
        ],
      ),
    );
  }
}

class _CharacterItem extends StatelessWidget {
  final Character character;
  _CharacterItem(this.character);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          character.name,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: Text(character.talent.period.descriptionDays),
      ),
    );
  }
}
