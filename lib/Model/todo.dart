final String tableTodo = 'todos';

class TodoFields {
  static final List<String> values = [
    id, title, done
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String done = 'done';
}

class Todo {
  final int? id;
  final String title;
  final bool done;

  const Todo({this.id, required this.title, required this.done});

  static Todo fromJson(Map<String, Object?> json) => Todo(
    id: json[TodoFields.id] as int?,
    title: json[TodoFields.title] as String,
    done: json[TodoFields.done] == 1);

  Map<String, Object?> toJson() => {
        TodoFields.id: id,
        TodoFields.title: title,
        TodoFields.done: done ? 1 : 0
      };

  Todo copy({int? id, String? title, bool? done}) => Todo(
      id: id ?? this.id, title: title ?? this.title, done: done ?? this.done);
}
