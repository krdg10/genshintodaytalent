import 'package:flutter/material.dart';
import 'package:genshintodaytalent/assets/ListGrid.dart';
import 'package:genshintodaytalent/database/dao/character_dao.dart';

// Estrutura do codigo pra comportar 2 casos tá pronta
// falta fazer o dropdown pegar, alterar de char pra weapon de fato. mandar e trazer a pesquisa certa

// ^^^aparententemte fiz, só testar mais

// pra reutilizar no artefato, no dropdown colocar um ? : e tal. E ai mostra um dropdown pra um caso de talento e outro pra caso de tipo.
// mesma coisa pra lista...

// depois disso, uma lista tipo isso separando por "artefato" de elevação
// e ai no profile, tornar o artefato clicavel e a data clicavel, pros seus respectivos locais

class ListPage extends StatefulWidget {
  final String type;
  final String group;

  ListPage({this.type = '', this.group = ''});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String title = '';
  String dropdownValue = 'Characters';
  @override
  Widget build(BuildContext context) {
    if (widget.type.length == 0) {
      title = dropdownValue;
    } else {
      if (widget.type == 'char') {
        title = 'Characters';
      } else {
        title = 'Weapons';
      }
    }

    final CharacterDao _characterDao = CharacterDao();

    return Scaffold(
      appBar: AppBar(
        title: Text('List of $title'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: widget.group.length > 0
            ? Column(
                children: [
                  Container(
                    child: DropdownButton(
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
                    ),
                  ),
                  ListGrid(
                    listOfCharsOrWeapons:
                        _characterDao.queryToFindAllCharactersOrWeaponsByGroup(
                            dropdownValue, widget.group),
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
