import 'package:genshintodaytalent/models/talent.dart';

class Character {
  final int id;
  final String name;
  final String? description;
  final String? photo;
  final Talent talent;
  final String type;
  final int stars;

  Character(
      {required this.id,
      required this.name,
      required this.talent,
      this.description,
      this.photo,
      required this.type,
      required this.stars});

  Character.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        type = json['type'],
        photo = json['photo'],
        stars = json['stars'],
        talent = Talent.fromJson(json['talent']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type,
        'photo': photo,
        'stars': stars,
        'talent': talent.toJson(),
      };
}
