import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:genshintodaytalent/database/dao/character_dao.dart';
import 'package:genshintodaytalent/database/dao/talent_dao.dart';
import 'package:genshintodaytalent/models/character.dart';
import 'package:genshintodaytalent/models/talent.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dao/period_dao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'vintequato.db');
  return openDatabase(
    path,
    onCreate: (db, version) async {
      await db.execute(PeriodDao.tableSql);
      await db.execute(PeriodDao.insert);
      await db.execute(PeriodDao.insertTwo);
      await db.execute(PeriodDao.insertThree);
      await db.execute(TalentDao.tableSql);
      await db.execute(CharacterDao.tableSql);

      Batch batch = db.batch();

      String talentsJson = await rootBundle.loadString('assets/talents.json');
      List talentsList = json.decode(talentsJson);
      talentsList.forEach((val) {
        Talent talent = Talent.fromMap(val);
        batch.insert('talents', talent.toMap());
      });

      String charactersJson =
          await rootBundle.loadString('assets/characters.json');
      List charactersList = json.decode(charactersJson);
      print(charactersList);
      charactersList.forEach((val) {
        Character character = Character.fromMap(val);
        batch.insert('characters', character.toMap());
      });

      batch.commit();
    },
    version: 24,
    //onDowngrade: onDatabaseDowngradeDelete,
  );
}
