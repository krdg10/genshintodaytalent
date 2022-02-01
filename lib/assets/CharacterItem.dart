import 'package:flutter/material.dart';
import 'package:genshintodaytalent/models/character.dart';
import 'package:genshintodaytalent/screens/profilePage.dart';

class CharacterItem extends StatelessWidget {
  final Character character;
  final Function onClick;

  const CharacterItem({
    Key? key,
    required this.character,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        height: 50,
        child: Column(
          children: [
            Image.asset(
              character.photo,
              height: 100,
              width: 100,
            ),
            Text(character.name)
          ],
        ),
      ),
    );
    /*  return Card(
      child: ListTile(
        title: Text(
          character.name,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: Text(character.talent.period.descriptionDays),
      ),
    );*/

    /*Card(
                    child: new GridTile(
                      //footer: new Text(data[index]),
                      child: new Text(data[index]), //just for testing, will fill with image later
                    ),*/
  }

  
}
