class TopicModel {
  final List<TopicCategory> topicCategories;
  final List<TopicSector> topicSectors;
  final List<String>? topicNames;

  TopicModel({
    required this.topicCategories,
    required this.topicSectors,
    this.topicNames,
  });

  factory TopicModel.fromMap(
    Map<String, dynamic> map
  ) {
    return TopicModel(
      topicCategories: (map['topicCategories'] as List? ?? [])
        .map(
          (e) => TopicCategory.fromMap(
            e as Map<String, dynamic>
          )
        ).toList(),
      topicSectors: (map['topicSectors'] as List? ?? [])
        .map(
          (e) => TopicSector.fromMap(
            e as Map<String, dynamic>
          )
        ).toList(),
      topicNames: (map['topicNames'] as List? ?? [])
        .map((e) => e.toString())
        .toList()
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topicCategories': topicCategories.map(
        (e) => e.toMap()
      ).toList(),
      'topicSectors': topicSectors.map(
        (e) => e.toMap()
      ).toList(),
      'topicNames': topicNames,
    };
  }
}

class TopicCategory {
  final String id;
  final String name;

  TopicCategory({
    required this.id,
    required this.name,
  });

  factory TopicCategory.fromMap(Map<String, dynamic> map) {
    return TopicCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class TopicSector {
  final String id;
  final String name;

  TopicSector({
    required this.id,
    required this.name,
  });

  factory TopicSector.fromMap(
    Map<String, dynamic> map
  ) {
    return TopicSector(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
