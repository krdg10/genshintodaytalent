import 'package:flutter/foundation.dart';
import 'package:genshintodaytalent/database/dao/character_dao.dart';
import 'package:genshintodaytalent/database/dao/talent_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dao/period_dao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'genshitomorrow.db');
  return openDatabase(
    path,
    onCreate: (db, version) async {
      await db.execute(PeriodDao.tableSql);
      await db.execute(PeriodDao.insert);
      await db.execute(TalentDao.tableSql);
      await db.execute(TalentDao.insert);
      await db.execute(CharacterDao.tableSql);
      await db.execute(CharacterDao.insert);

      //talent dao dando BO. Nao cria a tabela talents... nao sei pq
    },
    version: 7,
    //onDowngrade: onDatabaseDowngradeDelete,
  );
}
