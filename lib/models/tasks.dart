class ImportantCard {
  const ImportantCard({
    required this.cardId,
    required this.items,
  });

  final String cardId;

  final List<Item> items;
}

class Item {
  Item({
    required this.taskId,
    required this.taskText,
  });

  final String taskId;

  final String taskText;

  bool completed = false;
}
