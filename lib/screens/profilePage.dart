import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
                  String descriptionDays = period.descriptionDays;
                  mine = convertIntToBool(widget.character.mine);
                  final snackBar = SnackBar(
                    content: const Text('Change complete with successfully'),
                  );
                  return Container(
                    child: ListView(scrollDirection: Axis.vertical, children: [
                      Container(
                        child: Image.asset(widget.character.banner),
                      ),
                      Center(
                        child: RatingBar.builder(
                          initialRating: widget.character.stars.toDouble(),
                          ignoreGestures: true,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.blue,
                          ),
                          onRatingUpdate: (_) {},
                        ),
                      ),
                      ListTile(
                        title: Text(widget.character.description),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                'Mine',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 20,
                              child: Switch(
                                value: mine,
                                onChanged: (value) {
                                  setState(() {
                                    mine = value;
                                  });
                                  _characterDao.updateMine(widget.character.id,
                                      widget.character.mine);
                                  widget.character.mine =
                                      convertBoolToInt(value);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                activeTrackColor: Colors.lightGreenAccent,
                                activeColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    height: 50,
                                    child: Image.asset(talent.photo),
                                  ),
                                ),
                                Text(
                                  talent.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Text(
                                    'Days of week: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(descriptionDays),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Text(talent.description),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Location: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                child: Image.asset(talent.location),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
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

/*
mine funcionando já... só tem que fazer att quando volta pra dashboard e tiver no mine

> colocar pra imagem expandir on tap. location e tal. 
> pedir aprovação

> Procurar por isso de expandir a imagem. E ver se tem algo que posso melhorar no design. Por ultimo e talvez outra versão, negócio de mudar o mine na hora de voltar.

 */