import 'package:flutter/material.dart';
import 'package:genshintodaytalent/assets/ListGrid.dart';
import 'package:genshintodaytalent/database/dao/character_dao.dart';
import 'package:genshintodaytalent/database/dao/talent_dao.dart';

class ListPage extends StatefulWidget {
  final String type;
  final String group;
  final String talent;

  ListPage({this.type = '', this.group = '', this.talent = ''});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String title = '';
  String dropdownValue = 'Characters';
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.group.length > 0) {
      if (widget.type.length > 0 && count == 0) {
        if (widget.type == 'char') {
          dropdownValue = 'Characters';
        } else {
          dropdownValue = 'Weapons';
        }
        count++;
      }
      title = dropdownValue + ' per day';
    } else if (widget.talent.length > 0) {
      if (widget.talent == 'etc' && count == 0) {
        print('entrou');
        dropdownValue = 'Transience';
      } else if (count == 0) {
        dropdownValue = widget.talent;
      }
      count++;
      title = dropdownValue;
    } else {
      if (widget.type == 'char') {
        title = 'Characters';
      } else {
        title = 'Weapons';
      }
    }

    final CharacterDao _characterDao = CharacterDao();
    final TalentDao _talentDao = TalentDao();

    return Scaffold(
      appBar: AppBar(
        title: Text('List of $title'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: widget.group.length > 0 || widget.talent.length > 0
            ? Column(
                children: [
                  Container(
                    child: widget.group.length > 0
                        ? DropdownButton(
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
                            },
                            items: <String>['Characters', 'Weapons']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        : FutureBuilder<List<String>>(
                            future: _talentDao.findAllTalentsNames(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Erro ao carregar os itens.');
                              } else if (snapshot.hasData) {
                                return DropdownButton<String>(
                                  value: dropdownValue,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.blue),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.blueAccent,
                                  ),
                                  onChanged: (String? selectedItem) {
                                    setState(() {
                                      dropdownValue = selectedItem!;
                                    });
                                  },
                                  items: snapshot.data!.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Text('No item founded');
                              }
                            },
                          ),
                  ),
                  ListGrid(
                    listOfCharsOrWeapons: widget.group.length > 0
                        ? _characterDao
                            .queryToFindAllCharactersOrWeaponsByGroup(
                                dropdownValue, widget.group)
                        : _characterDao
                            .queryToFindAllCharactersOrWeaponsByTalent(
                                dropdownValue),
                    height:
                        (MediaQuery.of(context).size.height - 78 - 66).toInt(),
                  ),
                ],
              )
            : ListGrid(
                listOfCharsOrWeapons:
                    _characterDao.findAllWeaponOrChar(widget.type),
                height: (MediaQuery.of(context).size.height - 78 - 16).toInt(),
              ),
      ),
    );
  }
}
