import 'dart:convert';


class Talent {
  final int id;
  final String name;
  final String description;
  final String location;
  final String photo;
  final int periodGroup;
  Talent({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.photo,
    required this.periodGroup,
  });

  Talent copyWith({
    int? id,
    String? name,
    String? description,
    String? location,
    String? photo,
    int? periodGroup,
  }) {
    return Talent(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      photo: photo ?? this.photo,
      periodGroup: periodGroup ?? this.periodGroup,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'photo': photo,
      'periodGroup': periodGroup,
    };
  }

  factory Talent.fromMap(Map<String, dynamic> map) {
    return Talent(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      photo: map['photo'] ?? '',
      periodGroup: map['periodGroup'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Talent.fromJson(String source) => Talent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Talent(id: $id, name: $name, description: $description, location: $location, photo: $photo, periodGroup: $periodGroup)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Talent &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.location == location &&
        other.photo == photo &&
        other.periodGroup == periodGroup;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        location.hashCode ^
        photo.hashCode ^
        periodGroup.hashCode;
  }
}
