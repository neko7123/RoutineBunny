enum RoutineCategory {
  skincare,
  medication,
  hydration,
  wellness,
  household,
  custom
}

class RoutineItem {
  const RoutineItem({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.photoPath,
    this.customFields = const {},
    this.isPaused = false,
    this.isArchived = false,
  });

  final String id;
  final String name;
  final RoutineCategory category;
  final String? description;
  final String? photoPath;
  final Map<String, String> customFields;
  final bool isPaused;
  final bool isArchived;

  RoutineItem copyWith(
      {String? name,
      RoutineCategory? category,
      String? description,
      String? photoPath,
      bool? isPaused,
      bool? isArchived}) {
    return RoutineItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      photoPath: photoPath ?? this.photoPath,
      customFields: customFields,
      isPaused: isPaused ?? this.isPaused,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'category': category.name,
        'description': description,
        'photoPath': photoPath,
        'customFields': customFields,
        'isPaused': isPaused,
        'isArchived': isArchived,
      };

  factory RoutineItem.fromJson(Map<String, Object?> json) {
    final categoryName =
        json['category'] as String? ?? RoutineCategory.custom.name;
    return RoutineItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: RoutineCategory.values.firstWhere(
          (value) => value.name == categoryName,
          orElse: () => RoutineCategory.custom),
      description: json['description'] as String?,
      photoPath: json['photoPath'] as String?,
      customFields: Map<String, String>.from((json['customFields'] as Map?)
              ?.map((key, value) => MapEntry('$key', '$value')) ??
          const {}),
      isPaused: json['isPaused'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }
}
