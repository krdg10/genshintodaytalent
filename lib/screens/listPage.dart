import 'package:flutter/material.dart';
import 'package:genshintodaytalent/assets/ListGrid.dart';
import 'package:genshintodaytalent/database/dao/character_dao.dart';

class ListPage extends StatelessWidget {
  final String type;
  const ListPage({required this.type});

  @override
  Widget build(BuildContext context) {
    final CharacterDao _characterDao = CharacterDao();
    return Scaffold(
      appBar: AppBar(
        title: Text('List of $type'),
      ),
      body: ListGrid(
        listOfCharsOrWeapons: _characterDao.findAllWeaponOrChar(type),
      ),
    );
  }
}
