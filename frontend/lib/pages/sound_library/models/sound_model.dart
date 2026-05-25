class SoundModel {
  final String id;
  final String name;
  final String category;
  final Duration duration;
  final String url;
  final bool archived;
  final DateTime createdAt;

  SoundModel({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.url,
    required this.createdAt,
    this.archived = false,
  });

  // Logic for persistence or comparison can be added here
  SoundModel copyWith({
    String? name,
    String? category,
    bool? archived,
    DateTime? createdAt,
  }) {
    return SoundModel(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      duration: duration,
      url: url,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
