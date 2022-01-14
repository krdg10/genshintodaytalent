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
      body: Container(
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: 100, child: Image.asset('images/Logo.png')),
            Container(
              height: 500,
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
                              return _CharacterItem(character);
                            },
                          ),
                        );
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
}

class _CharacterItem extends StatelessWidget {
  final Character character;
  _CharacterItem(this.character);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        children: [Image.asset(character.photo), Text(character.name)],
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
