import 'package:genshintodaytalent/models/period.dart';

class Talent {
  final int id;
  final String name;
  final String? description;
  final String? location;
  final String? photo;
  final Period period;

  Talent({
    required this.id,
    required this.name,
    required this.period,
    this.description,
    this.photo,
    this.location,
  });

  Talent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        location = json['location'],
        photo = json['photo'],
        period = Period.fromJson(json['period']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'location': location,
        'photo': photo,
        'period': period.toJson(),
      };
}
