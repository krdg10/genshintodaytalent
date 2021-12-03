class Period {
  final int id;
  final String descriptionDays;
  final int group;

  Period(
      {required this.id, required this.descriptionDays, required this.group});

  Map<String, dynamic> toJson() => {
        'id': id,
        'description_days': descriptionDays,
        'grupo': group,
      };

  Period.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        descriptionDays = json['description_days'],
        group = json['grupo'];

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Period &&
          runtimeType == other.runtimeType &&
          descriptionDays == other.descriptionDays &&
          group == other.group;

  @override
  int get hashCode => descriptionDays.hashCode ^ group.hashCode;
}
