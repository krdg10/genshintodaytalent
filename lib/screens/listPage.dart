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
  String subtitle = '';

  // Método para atualizar o valor do dropdown
  void _updateDropdownValue(String? newValue) {
    if (newValue != null) {
      setState(() {
        dropdownValue = newValue;
      });
    }
  }

  // Método para construir o DropdownButton
  Widget _buildDropdownButton(List<String> items) {
    return DropdownButton(
      value: dropdownValue,
      elevation: 16,
      style: const TextStyle(color: Colors.blue),
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      onChanged: _updateDropdownValue,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CharacterDao _characterDao = CharacterDao();
    final TalentDao _talentDao = TalentDao();

    if (widget.group.length > 0) {
      if (widget.type.length > 0 && count == 0) {
        dropdownValue = widget.type == 'char' ? 'Characters' : 'Weapons';
        count++;
      }
      if (widget.group == '1') {
        subtitle = 'Monday and Thursday';
      } else if (widget.group == '2') {
        subtitle = 'Tuesday and Friday';
      } else {
        subtitle = 'Wednesday and Saturday';
      }
      title = dropdownValue + ' of ' + subtitle;
    } else if (widget.talent.length > 0) {
      if ((widget.talent == 'etc' && count == 0) || count == 0) {
        dropdownValue = widget.talent == 'etc' ? 'Transience' : widget.talent;
      }
      count++;
      title = dropdownValue;
    } else {
      title = widget.type == 'char' ? 'Characters' : 'Weapons';
    }

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
                        ? _buildDropdownButton(['Characters', 'Weapons'])
                        : FutureBuilder<List<String>>(
                            future: _talentDao.findAllTalentsNames(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error in loading.');
                              } else if (snapshot.hasData) {
                                return _buildDropdownButton(snapshot.data!);
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
