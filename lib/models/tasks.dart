class CardDataModel {
  // Tasks user listed
  // ex. 1. Do Homework (check btn) (edit btn) (del btn)
  List<Item> importantItems = [];
  List<Item> unimportantItems = [];

  // Make the items to one list
  toListImp() {
    return importantItems.map((singleItem) => singleItem.toJson()).toList();
  }

  toListUnimp() {
    return unimportantItems.map((singleItem) => singleItem.toJson()).toList();
  }
}

class Item {
  Item({
    required this.taskId,
    required this.taskText,
    required this.completed,
    this.priority,
    this.time,
  });

  final String taskId;

  final String taskText;

  final int? priority;

  final DateTime? time;

  bool completed;

  toJson() {
    Map<String, dynamic> itemData = {};
    itemData["taskId"] = taskId;
    itemData["taskText"] = taskText;
    itemData["priority"] = priority;
    itemData["completed"] = completed;
    itemData["time"] = time.toString();

    return itemData;
  }
}
