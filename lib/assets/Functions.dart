import 'package:flutter/material.dart';
import 'package:genshintodaytalent/models/character.dart';
import 'package:genshintodaytalent/screens/profilePage.dart';

class Functions {

  void showCharacterProfile(BuildContext context, Character character) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfilePage(character: character),
      ),
    );
  }
  
}