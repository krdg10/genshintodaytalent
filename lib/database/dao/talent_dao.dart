import 'dart:developer';

import 'package:genshintodaytalent/database/dao/period_dao.dart';
import 'package:genshintodaytalent/models/period.dart';
import 'package:genshintodaytalent/models/talent.dart';
import 'package:sqflite/sqflite.dart';

import '../app_database.dart';

class TalentDao {
  static const String tableSql =
      'CREATE TABLE $_tableName($_id INTEGER PRIMARY KEY, $_name varchar(250), $_description varchar(1000), $_period INTEGER, $_photo varchar(1000), $_location varchar(1000), FOREIGN KEY($_period) REFERENCES periods(id))';

  static const String insert =
      "insert into $_tableName($_name, $_description, $_period, $_photo, $_location) values ('Freedom', 'ablablue', '1', 'https://s3.us-east-1.amazonaws.com/gamewith-en/article_tools/genshin-impact/gacha/s_i_65.png', 'ablablue')";

  static const String _tableName = 'talents';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _description = 'description';
  static const String _period = 'periodID';
  static const String _photo = 'photo';
  static const String _location = 'location';

  Future<List<Talent>> findAll() async {
    final Database db = await getDatabase();

    final result = await db.query(_tableName);

    Future<List<Talent>> talents = _toList(result);

    return talents;
  }

  Future<Talent> findOne(int id) async {
    final Database db = await getDatabase();

    final result = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    List<Talent> talent = await _toList(result);
    return talent[0];
  }

  Future<List<Talent>> _toList(List<Map<String, dynamic>> result) async {
    final List<Talent> talents = [];
    final PeriodDao period = PeriodDao();
    for (Map<String, dynamic> row in result) {
      final Talent talent = Talent(
        id: row[_id],
        name: row[_name],
        description: row[_description],
        period: await period.findOne(row[_period]),
        photo: row[_photo],
        location: row[_location],
      );
      talents.add(talent);
    }
    return talents;
  }
}
