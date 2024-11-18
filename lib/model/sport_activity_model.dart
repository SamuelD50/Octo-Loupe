class SportCategories {
  final String name;
  final String image;

  SportCategories({
    required this.name,
    required this.image,
  });

  //Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory SportCategories.fromMap(Map<String, dynamic> map) {
    return SportCategories(
      name: map['name'],
      image: map['image'],
    );
  }
}

class SportAges {
  final String name;
  final String image;

  SportAges({
    required this.name,
    required this.image,
  });

  //Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory SportAges.fromMap(Map<String, dynamic> map) {
    return SportAges(
      name: map['name'],
      image: map['image'],
    );
  }
}

class SportDays {
  final String name;
  final String image;

  SportDays({
    required this.name,
    required this.image,
  });

  //Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory SportDays.fromMap(Map<String, dynamic> map) {
    return SportDays(
      name: map['name'],
      image: map['image'],
    );
  }
}

class SportSchedules {
  final String name;
  final String image;

  SportSchedules({
    required this.name,
    required this.image,
  });

  //Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory SportSchedules.fromMap(Map<String, dynamic> map) {
    return SportSchedules(
      name: map['name'],
      image: map['image'],
    );
  }
}

class SportSectors {
  final String name;
  final String image;

  SportSectors({
    required this.name,
    required this.image,
  });

  //Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory SportSectors.fromMap(Map<String, dynamic> map) {
    return SportSectors(
      name: map['name'],
      image: map['image'],
    );
  }
}