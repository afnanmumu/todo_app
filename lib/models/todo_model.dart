class TodoModel {
  late String id;
  final String title;
  final String description;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
    );
  }
}