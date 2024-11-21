class CultureFilterModel {
  final List<CultureCategory> categories;
  final List<CultureAge> ages;
  final List<CultureDay> days;
  final List<CultureSchedule> schedules;
  final List<CultureSector> sectors;

  CultureFilterModel({
    required this.categories,
    required this.ages,
    required this.days,
    required this.schedules,
    required this.sectors,
  });

  factory CultureFilterModel.fromJson(Map<String, dynamic> json) {
    var categoriesFromJson = json['categories'] as List? ?? [];
    var agesFromJson = json['ages'] as List? ?? [];
    var daysFromJson = json['days'] as List? ?? [];
    var schedulesFromJson = json['schedules'] as List? ?? [];
    var sectorsFromJson = json['sectors'] as List? ?? [];
  
    return CultureFilterModel(
      categories: categoriesFromJson.map((e) => CultureCategory.fromJson(e)).toList(),
      ages: agesFromJson.map((e) => CultureAge.fromJson(e)).toList(),
      days: daysFromJson.map((e) => CultureDay.fromJson(e)).toList(),
      schedules: schedulesFromJson.map((e) => CultureSchedule.fromJson(e)).toList(),
      sectors: sectorsFromJson.map((e) => CultureSector.fromJson(e)).toList(),
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

class CultureCategory {
  final String name;
  final String image;

  CultureCategory({
    required this.name,
    required this.image,
  });

  factory CultureCategory.fromJson(Map<String, dynamic> json) {
    return CultureCategory(
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

class CultureAge {
  final String name;
  final String image;

  CultureAge({
    required this.name,
    required this.image,
  });

  factory CultureAge.fromJson(Map<String, dynamic> json) {
    return CultureAge(
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

class CultureDay {
  final String name;
  final String image;

  CultureDay({
    required this.name,
    required this.image,
  });

  factory CultureDay.fromJson(Map<String, dynamic> json) {
    return CultureDay(
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

class CultureSchedule {
  final String name;
  final String image;

  CultureSchedule({
    required this.name,
    required this.image,
  });

  factory CultureSchedule.fromJson(Map<String, dynamic> json) {
    return CultureSchedule(
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

class CultureSector {
  final String name;
  final String image;

  CultureSector({
    required this.name,
    required this.image,
  });

  factory CultureSector.fromJson(Map<String, dynamic> json) {
    return CultureSector(
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
