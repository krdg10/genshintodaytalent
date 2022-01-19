import 'dart:convert';

class Character {
  final int id;
  final String name;
  final String? description;
  final String photo;
  final int talentID;
  final String type;
  final int stars;
  final int mine;
  Character({
    required this.id,
    required this.name,
    this.description,
    required this.photo,
    required this.talentID,
    required this.type,
    required this.stars,
    this.mine = 0,
  });

  Character copyWith({
    int? id,
    String? name,
    String? description,
    String? photo,
    int? talentID,
    String? type,
    int? stars,
    int? mine,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      talentID: talentID ?? this.talentID,
      type: type ?? this.type,
      stars: stars ?? this.stars,
      mine: mine ?? this.mine,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'photo': photo,
      'talentID': talentID,
      'type': type,
      'stars': stars,
      'mine': mine,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      photo: map['photo'] ?? '',
      talentID: map['talentID'] ?? 0,
      type: map['type'] ?? '',
      stars: map['stars'] ?? 0,
      mine: map['mine'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Character.fromJson(String source) =>
      Character.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Character(id: $id, name: $name, description: $description, photo: $photo, talentID: $talentID, type: $type, stars: $stars, mine: $mine)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.photo == photo &&
        other.talentID == talentID &&
        other.type == type &&
        other.stars == stars &&
        other.mine == mine;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        photo.hashCode ^
        talentID.hashCode ^
        type.hashCode ^
        stars.hashCode ^
        mine.hashCode;
  }
}
