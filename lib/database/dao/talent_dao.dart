import 'package:genshintodaytalent/database/dao/period_dao.dart';
import 'package:genshintodaytalent/models/period.dart';
import 'package:genshintodaytalent/models/talent.dart';
import 'package:sqflite/sqflite.dart';

import '../app_database.dart';

class TalentDao {
  static const String tableSql =
      'CREATE TABLE $_tableName($_id INTEGER PRIMARY KEY, $_name varchar(250), $_description varchar(1000), $_period INTEGER, $_photo varchar(1000), $_location varchar(1000), FOREIGN KEY($_period) REFERENCES periods(id))';

  static const String _tableName = 'talents';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _description = 'description';
  static const String _period = 'periodGroup';
  static const String _photo = 'photo';
  static const String _location = 'location';

  Future<List<Talent>> findAll() async {
    final Database db = await getDatabase();

    final result = await db.query(_tableName);

    Future<List<Talent>> talents = _toList(result);

    return talents;
  }

  Future<List<String>> findAllTalentsNames() async {
    /*List<String> namelist = [];

    await findAll().then((listOfTalents) {
      
      listOfTalents.map((talent) {
        print(talent);
        namelist.add(talent.name);
        print(talent.name);
      });
    });
  

    return namelist;
    
    meu código era esse acima mas pedi pro chatgpt corrigir e veio o abaixo. o then era o problema. mas zoado que ontem tava dando certo...
    eu acho pelo menos. e nem lembro de ter feito outra versão que eu otimizei ou sla
    */

    List<String> namelist = [];

    List<Talent> listOfTalents = await findAll();

    for (Talent talent in listOfTalents) {
      namelist.add(talent.name);
    }

    return namelist;
  }

  Future<dynamic> findOne(int id) async {
    final Database db = await getDatabase();

    final result = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    List<Talent> talent = await _toList(result);
    final resultPeriod = await db
        .query('periods', where: 'id = ?', whereArgs: [talent[0].periodGroup]);
    List<Period> period = PeriodDao().toList(resultPeriod);
    List<dynamic> data = [];
    data.add(talent[0]);
    data.add(period[0]);

    return data;
  }

  Future<List<Talent>> _toList(List<Map<String, dynamic>> result) async {
    final List<Talent> talents = [];
    for (Map<String, dynamic> row in result) {
      final Talent talent = Talent(
        id: row[_id],
        name: row[_name],
        description: row[_description],
        periodGroup: row[_period],
        photo: row[_photo],
        location: row[_location],
      );
      talents.add(talent);
    }
    return talents;
  }
}
