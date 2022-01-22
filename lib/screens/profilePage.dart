import 'package:flutter/material.dart';
import 'package:genshintodaytalent/database/dao/talent_dao.dart';
import 'package:genshintodaytalent/models/character.dart';
import 'package:genshintodaytalent/models/period.dart';
import 'package:genshintodaytalent/models/talent.dart';

class ProfilePage extends StatelessWidget {
  final Character character;
  ProfilePage({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _talentDao = TalentDao();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(character.name),
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: _talentDao.findOne(character.talentID),
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
                  Talent talent = list[0];
                  Period period = list[1];
                  return Container(
                    child: Column(
                      children: [
                        Text(talent.description),
                        Container(
                          child: Image.asset(character.banner),
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
}