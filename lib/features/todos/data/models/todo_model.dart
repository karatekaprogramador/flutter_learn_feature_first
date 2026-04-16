class TodoModel {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final String userId;
  final DateTime createdAt;

  TodoModel({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.userId,
    required this.createdAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'is_completed': isCompleted,
    };
  }
}
