const String tableOftodos = 'TODOs';

class TODOFields {
  static final List<String> values = [
    id, title, description, time
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

class TODO {
  final int? id;
  final String title;
  final String description;
  final DateTime createdTime;

  const TODO({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  TODO copy({
    int? id,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      TODO(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static TODO fromJson(Map<String, Object?> json) => TODO(
    id: json[TODOFields.id] as int?,
    title: json[TODOFields.title] as String,
    description: json[TODOFields.description] as String,
    createdTime: DateTime.parse(json[TODOFields.time] as String),
  );

  Map<String, Object?> toJson() => {
    TODOFields.id: id,
    TODOFields.title: title,
    TODOFields.description: description,
    TODOFields.time: createdTime.toIso8601String(),
  };
}