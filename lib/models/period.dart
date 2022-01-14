import 'dart:convert';

class Period {
  final int id;
  final String descriptionDays;
  final int group;
  Period({
    required this.id,
    required this.descriptionDays,
    required this.group,
  });


  Period copyWith({
    int? id,
    String? descriptionDays,
    int? group,
  }) {
    return Period(
      id: id ?? this.id,
      descriptionDays: descriptionDays ?? this.descriptionDays,
      group: group ?? this.group,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descriptionDays': descriptionDays,
      'group': group,
    };
  }

  factory Period.fromMap(Map<String, dynamic> map) {
    return Period(
      id: map['id'] ?? 0,
      descriptionDays: map['descriptionDays'] ?? '',
      group: map['group'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Period.fromJson(String source) => Period.fromMap(json.decode(source));

  @override
  String toString() => 'Period(id: $id, descriptionDays: $descriptionDays, group: $group)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Period &&
      other.id == id &&
      other.descriptionDays == descriptionDays &&
      other.group == group;
  }

  @override
  int get hashCode => id.hashCode ^ descriptionDays.hashCode ^ group.hashCode;
}
