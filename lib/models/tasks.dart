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
    required this.taskText,
    required this.completed,
    required this.taskType,
    required this.taskId,
    this.time,
  });

  final String taskType;
  final String taskId;
  final DateTime? time;

  bool notiState = false;
  String taskText;
  bool completed;

  toJson() {
    Map<String, dynamic> itemData = {};
    itemData["taskId"] = taskId;
    itemData["taskText"] = taskText;
    itemData["completed"] = completed;
    itemData["time"] = time.toString();
    itemData["taskType"] = taskType;
    itemData["notiState"] = notiState;

    return itemData;
  }
}
