import 'dart:convert';

class Todos {
  String userId;
  String id;
  String title;
  String completed;

  Todos({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todos.fromJson(Map<String, dynamic> map) {
    return Todos(
      userId: map["userId"].toString(),
      id: map["id"].toString(),
      title: map["title"].toString(),
      completed: map["completed"].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "id": id,
      "title": title,
      "completed": completed,
    };
  }

  @override
  String toString() {
    return 'Todos{userId: $userId, id: $id, title: $title, completed: $completed}';
  }
}

List<Todos> todosFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Todos>.from(data.map((item) => Todos.fromJson(item)));
}

String todosToJson(Todos data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
