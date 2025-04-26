class TodoItem {
  final int id;
  String title;
  bool isCompleted = false;
  String content;

  TodoItem({
    required this.id,
    required this.title,
    required this.content,
    required this.isCompleted,
  });

  void toggleIsCompleted() => isCompleted = !isCompleted;
}
