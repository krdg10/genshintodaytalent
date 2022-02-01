import 'package:flutter/material.dart';
import 'package:genshintodaytalent/assets/CharacterItem.dart';
import 'package:genshintodaytalent/assets/Functions.dart';
import 'package:genshintodaytalent/models/character.dart';

class ListGrid extends StatelessWidget {
  final Future<List<Character>> listOfCharsOrWeapons;
  const ListGrid({required this.listOfCharsOrWeapons});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 500,
      child: ListView(scrollDirection: Axis.vertical, children: [
        FutureBuilder(
          future: listOfCharsOrWeapons,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text('Loading'),
                    ],
                  ),
                );

              case ConnectionState.active:
                break;
              case ConnectionState.done:
                final List<Character> characters =
                    snapshot.data as List<Character>;

                if (characters.length == 0) {
                  return Container(
                    child: Text('This category dont have characters'),
                  );
                } else {
                  return Container(
                    height: 400,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: characters.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        final Character character = characters[index];
                        return CharacterItem(
                          character: character,
                          onClick: () => Functions()
                              .showCharacterProfile(context, character),
                        );
                      },
                    ),
                  );
                }
            }

            return Text('Unknowm error');
          },
        )
      ]),
    );
  }
}
