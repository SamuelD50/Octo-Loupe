class SportFilterModel {
  final List<SportCategory> categories;
  final List<SportAge> ages;
  final List<SportDay> days;
  final List<SportSchedule> schedules;
  final List<SportSector> sectors;

  SportFilterModel({
    required this.categories,
    required this.ages,
    required this.days,
    required this.schedules,
    required this.sectors,
  });

  factory SportFilterModel.fromJson(Map<String, dynamic> json) {
    var categoriesFromJson = json['categories'] as List? ?? [];
    var agesFromJson = json['ages'] as List? ?? [];
    var daysFromJson = json['days'] as List? ?? [];
    var schedulesFromJson = json['schedules'] as List? ?? [];
    var sectorsFromJson = json['sectors'] as List? ?? [];
  
    return SportFilterModel(
      categories: categoriesFromJson.map((e) => SportCategory.fromJson(e)).toList(),
      ages: agesFromJson.map((e) => SportAge.fromJson(e)).toList(),
      days: daysFromJson.map((e) => SportDay.fromJson(e)).toList(),
      schedules: schedulesFromJson.map((e) => SportSchedule.fromJson(e)).toList(),
      sectors: sectorsFromJson.map((e) => SportSector.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories' : categories.map((e) => e.toJson()).toList(),
      'ages' : ages.map((e) => e.toJson()).toList(),
      'days' : days.map((e) => e.toJson()).toList(),
      'schedules' : schedules.map((e) => e.toJson()).toList(),
      'sectors' : sectors.map((e) => e.toJson()).toList(),
    };
  }
}

class SportCategory {
  final String name;
  final String image;

  SportCategory({
    required this.name,
    required this.image,
  });

  factory SportCategory.fromJson(Map<String, dynamic> json) {
    return SportCategory(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
    };
  }
}

class SportAge {
  final String name;
  final String image;

  SportAge({
    required this.name,
    required this.image,
  });

  factory SportAge.fromJson(Map<String, dynamic> json) {
    return SportAge(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
    };
  }
}

class SportDay {
  final String name;
  final String image;

  SportDay({
    required this.name,
    required this.image,
  });

  factory SportDay.fromJson(Map<String, dynamic> json) {
    return SportDay(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
    };
  }
}

class SportSchedule {
  final String name;
  final String image;

  SportSchedule({
    required this.name,
    required this.image,
  });

  factory SportSchedule.fromJson(Map<String, dynamic> json) {
    return SportSchedule(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
    };
  }
}

class SportSector {
  final String name;
  final String image;

  SportSector({
    required this.name,
    required this.image,
  });

  factory SportSector.fromJson(Map<String, dynamic> json) {
    return SportSector(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
    };
  }
}
