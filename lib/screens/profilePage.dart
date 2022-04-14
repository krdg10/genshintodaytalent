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
  final _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;
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
                    content: const Text('Changes saved with success.'),
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
                              child: GestureDetector(
                                onDoubleTapDown: _handleDoubleTapDown,
                                onDoubleTap: _handleDoubleTap,
                                child: InteractiveViewer(
                                  boundaryMargin: const EdgeInsets.all(20.0),
                                  transformationController:
                                      _transformationController,
                                  minScale: 0.1,
                                  maxScale: 2,
                                  child: Container(
                                    child: Image.asset(talent.location),
                                  ),
                                ),
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

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }
  }
}

/**** proximo passo fazer internacionalização
 * 
 * 
 * https://docs.flutter.dev/deployment/android
 * https://dev.to/felipemsfg/publicacao-automatica-de-um-app-flutter-na-playstore-com-github-actions-i4b
 * https://pub.dev/packages/flutter_launcher_icons
 * https://stackoverflow.com/questions/43928702/how-to-change-the-application-launcher-icon-on-flutter
 * https://developer.android.com/studio/build/multidex#multidexkeepfile-property
 * https://developer.android.com/studio/build/multidex
 * 
 * 
 * 
 * publicar na playstore
 * ler sobre multiplex (manual)
 * ler sobre sincronização automatica (primeiro link, ja que ja passei do primeiro passo)
 *  * testar build com appbundle
 * ou deixar pra publicar depois de ler... n sei. talvez seja mais util ver a melhor forma, seja sync automatica ou appbundle
 */