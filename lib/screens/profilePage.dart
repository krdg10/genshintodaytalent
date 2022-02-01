import 'package:flutter/material.dart';
import 'package:genshintodaytalent/database/dao/character_dao.dart';
import 'package:genshintodaytalent/database/dao/talent_dao.dart';
import 'package:genshintodaytalent/models/character.dart';
import 'package:genshintodaytalent/models/period.dart';
import 'package:genshintodaytalent/models/talent.dart';

class ProfilePage extends StatefulWidget {
  Character character;
  ProfilePage({Key? key, required this.character}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final _talentDao = TalentDao();
    final _characterDao = CharacterDao();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.character.name),
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: _talentDao.findOne(widget.character.talentID),
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
                  final list = snapshot.data as List;
                  bool mine;
                  Talent talent = list[0];
                  Period period = list[1];
                  mine = convertIntToBool(widget.character.mine);
                  return Container(
                    child: Column(
                      children: [
                        Text(talent.description),
                        Container(
                          child: Image.asset(widget.character.banner),
                        ),
                        Switch(
                          value: mine,
                          onChanged: (value) {
                            setState(() {
                              print(mine);
                              mine = value;
                              print(mine);
                            });
                            _characterDao.updateMine(
                                widget.character.id, widget.character.mine);
                            widget.character.mine = convertBoolToInt(value);
                          },
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  );
              }
              return Text('Unknowm error');
            }),
      ),
    );
  }

  bool convertIntToBool(int number) {
    if (number == 0) {
      return false;
    }
    return true;
  }

  int convertBoolToInt(bool value) {
    if (value == false) {
      return 0;
    }
    return 1;
  }
}