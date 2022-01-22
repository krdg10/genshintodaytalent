import 'package:genshintodaytalent/models/character.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import '../app_database.dart';

class CharacterDao {
  static const String tableSql =
      'CREATE TABLE $_tableName($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_name varchar(250), $_description varchar(1000), $_talent INTEGER, $_photo varchar(1000), $_banner varchar(1000), $_type varchar(100), $_stars integer, $_mine INTEGER, FOREIGN KEY($_talent) REFERENCES talents(id))';

  static const String _tableName = 'characters';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _description = 'description';
  static const String _talent = 'talentID';
  static const String _photo = 'photo';
  static const String _type = 'type';
  static const String _stars = 'stars';
  static const String _mine = 'mine';
  static const String _banner = 'banner';

  Future<List<Character>> findAll() async {
    final Database db = await getDatabase();
    final result = await db.query(_tableName);
    Future<List<Character>> characters = _toList(result);
    return characters;
  }

  Future<List<Character>> findToday(String dropdownValue) async {
    var date = DateTime.now();
    var result;
    final Database db = await getDatabase();

    if (dropdownValue == 'Characters') {
      result = await queryWhenDropdownOnlyCharactersorWeapons(date, db, 'char');
    } else if (dropdownValue == 'Weapons') {
      result =
          await queryWhenDropdownOnlyCharactersorWeapons(date, db, 'weapon');
    } else if (dropdownValue == 'All') {
      result = await queryWhenDropdownAllCharactersAndWeaponsToday(date, db);
    } else if (dropdownValue == 'Mine Characters') {
      result =
          await queryWhenDropdownOnlyMineCharactersorWeapons(date, db, 'char');
    } else if (dropdownValue == 'Mine Weapons') {
      result = await queryWhenDropdownOnlyMineCharactersorWeapons(
          date, db, 'weapon');
    } else if (dropdownValue == 'All Mine') {
      result = await queryWhenDropdownAllMineCharactersAndWeapons(date, db);
    }

    if (result == null) {
      result =
          await db.query(_tableName, where: 'type = ?', whereArgs: ['none']);

      /// se tiver um jeito de transformar em lista sem a pesquisa seria melhor
    }
    Future<List<Character>> characters = _toList(result);
    return characters;
  }

  Future<dynamic> queryWhenDropdownOnlyCharactersorWeapons(
      DateTime date, Database db, String type) async {
    var groupNumber;
    var result;
    groupNumber = verifyGroupNumber(date);

    if (groupNumber == 4) {
      result =
          await db.query(_tableName, where: 'type = ?', whereArgs: ['$type']);
    } else {
      result = await db.rawQuery(
          'SELECT char.* from characters as char inner join talents as talent where char.talentID = talent.id and talent.periodGroup = ? and char.type = ?',
          [groupNumber, '$type']);
    }

    return result;
  }

  Future<dynamic> queryWhenDropdownAllCharactersAndWeaponsToday(
      DateTime date, Database db) async {
    var groupNumber;
    var result;
    groupNumber = verifyGroupNumber(date);

    if (groupNumber == 4) {
      result = await db.query(_tableName);
    } else {
      result = await db.rawQuery(
          'SELECT char.* from characters as char inner join talents as talent where char.talentID = talent.id and talent.periodGroup = ?',
          [groupNumber]);
    }
    print(result);
    return result;
  }

  Future<dynamic> queryWhenDropdownOnlyMineCharactersorWeapons(
      DateTime date, Database db, String type) async {
    var groupNumber;
    var result;
    groupNumber = verifyGroupNumber(date);

    if (groupNumber == 4) {
      result = await db.query(_tableName,
          where: 'type = ? and mine = ?', whereArgs: ['$type', 1]);
    } else {
      result = await db.rawQuery(
          'SELECT char.* from characters as char inner join talents as talent where char.talentID = talent.id and talent.periodGroup = ? and char.type = ? and char.mine = ?',
          [groupNumber, '$type', 1]);
    }

    return result;
  }

  Future<dynamic> queryWhenDropdownAllMineCharactersAndWeapons(
      DateTime date, Database db) async {
    var groupNumber;
    var result;
    groupNumber = verifyGroupNumber(date);

    if (groupNumber == 4) {
      result = await db.query(_tableName, where: 'mine = ?', whereArgs: [1]);
    } else {
      result = await db.rawQuery(
          'SELECT char.* from characters as char inner join talents as talent where char.talentID = talent.id and talent.periodGroup = ? and char.mine = ?',
          [groupNumber, 1]);
    }

    return result;
  }

  verifyGroupNumber(DateTime date) {
    var groupNumber;
    if (DateFormat('EEEE').format(date) == 'Monday' ||
        DateFormat('EEEE').format(date) == 'Thursday') {
      groupNumber = 1;
    } else if (DateFormat('EEEE').format(date) == 'Tuesday' ||
        DateFormat('EEEE').format(date) == 'Friday') {
      groupNumber = 2;
    } else if (DateFormat('EEEE').format(date) == 'Wednesday' ||
        DateFormat('EEEE').format(date) == 'Saturday') {
      groupNumber = 3;
    } else {
      groupNumber = 4;
    }
    return groupNumber;
  }

  Future<List<Character>> _toList(List<Map<String, dynamic>> result) async {
    final List<Character> characters = [];
    for (Map<String, dynamic> row in result) {
      final Character character = Character(
          id: row[_id],
          name: row[_name],
          description: row[_description],
          talentID: row[_talent],
          photo: row[_photo],
          banner: row[_banner],
          type: row[_type],
          stars: row[_stars],
          mine: row[_mine]);
      characters.add(character);
    }
    return characters;
  }
}
