import 'package:genshintodaytalent/database/dao/talent_dao.dart';
import 'package:genshintodaytalent/models/character.dart';
import 'package:sqflite/sqflite.dart';

import '../app_database.dart';

class CharacterDao {
  static const String tableSql =
      'CREATE TABLE $_tableName($_id INTEGER PRIMARY KEY, $_name varchar(250), $_description varchar(1000), $_talent INTEGER, $_photo varchar(1000), $_type varchar(100), $_stars integer, FOREIGN KEY($_talent) REFERENCES talents(id))';

  static const String insert =
      "insert into $_tableName($_name, $_description, $_talent, $_photo, $_type, $_stars) values ('Diona', 'ablablue', '1', 'https://img.gamewith.net/article_tools/genshin-impact/gacha/chara_29.png', 'char', '4')";

  static const String _tableName = 'characters';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _description = 'description';
  static const String _talent = 'talentID';
  static const String _photo = 'photo';
  static const String _type = 'type';
  static const String _stars = 'stars';

  Future<List<Character>> findAll() async {
    final Database db = await getDatabase();
    final result = await db.query(_tableName);
    Future<List<Character>> characters = _toList(result);

    return characters;
  }

  Future<List<Character>> _toList(List<Map<String, dynamic>> result) async {
    final List<Character> characters = [];
    final TalentDao talent = TalentDao();

    for (Map<String, dynamic> row in result) {
      final Character character = Character(
        id: row[_id],
        name: row[_name],
        description: row[_description],
        talent: await talent.findOne(row[_talent]),
        photo: row[_photo],
        type: row[_type],
        stars: row[_stars],
      );
      characters.add(character);
    }
    return characters;
  }
}
