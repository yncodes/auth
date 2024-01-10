class Todo {
  final int? id;
  final String? title;
  final String? todo;

  Todo({
    required this.id,
    required this.title,
    required this.todo,
  });

  // Named constructor for creating a Todo from a map (e.g., from the database)
  Todo.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        todo = map['todo'];

  // Factory constructor for creating a Todo from JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      todo: json['todo'],
    );
  }

  // Convert Todo to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'todo': todo,
    };
  }
}