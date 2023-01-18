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

  void clear() {
    importantItems.clear();
    unimportantItems.clear();
  }
}

class Item {
  Item({
    required this.taskId,
    required this.taskText,
    required this.completed,
    this.time,
  });

  final String taskId;

  final DateTime? time;

  String taskText;
  bool completed;

  toJson() {
    Map<String, dynamic> itemData = {};
    itemData["taskId"] = taskId;
    itemData["taskText"] = taskText;
    itemData["completed"] = completed;
    itemData["time"] = time.toString();

    return itemData;
  }
}
