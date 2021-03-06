import 'package:genshintodaytalent/models/period.dart';
import 'package:sqflite/sqflite.dart';

import '../app_database.dart';

class PeriodDao {
  static const String tableSql =
      'CREATE TABLE $_tableName($_id INTEGER PRIMARY KEY, $_descriptionDays varchar(255), $_group INTEGER)';

  static const String insert =
      "insert into $_tableName($_id, $_descriptionDays, $_group) values (1, 'Monday and Thursday', 1)";
  static const String insertTwo =
      "insert into $_tableName($_id, $_descriptionDays, $_group) values (2, 'Tuesday and Friday', 2)";
  static const String insertThree =
      "insert into $_tableName($_id, $_descriptionDays, $_group) values (3, 'Wednesday and Saturday', 3)";

  static const String _tableName = 'periods';
  static const String _id = 'id';
  static const String _descriptionDays = 'description_days';
  static const String _group = 'grupo';

  Future<Period> findOne(int id) async {
    final Database db = await getDatabase();
    final result = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    List<Period> periods = toList(result);
    return periods[0];
  }

  List<Period> toList(List<Map<String, dynamic>> result) {
    final List<Period> periods = [];
    for (Map<String, dynamic> row in result) {
      final Period period = Period(
        id: row[_id],
        descriptionDays: row[_descriptionDays],
        group: row[_group],
      );
      periods.add(period);
    }

    return periods;
  }
}
