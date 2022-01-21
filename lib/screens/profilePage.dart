import 'package:flutter/material.dart';
import 'package:genshintodaytalent/models/character.dart';

class ProfilePage extends StatelessWidget {
  final Character character;
  const ProfilePage({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(character.name),
        ),
        body: Container());
  }
}
