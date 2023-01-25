import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo_time_app/api/noti_api.dart';
import 'package:todo_time_app/constant/vars.dart';
import 'package:todo_time_app/models/tasks.dart';
import 'package:todo_time_app/widget/add_button.dart';
import 'package:todo_time_app/widget/bot_nav_bar.dart';
import 'package:todo_time_app/widget/hours.dart';
import 'package:todo_time_app/widget/time.dart';
import 'package:todo_time_app/widget/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    this.time,
    super.key,
  });

  final DateTime? time;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorage nameStorage = LocalStorage(usernameFile);
  final CardDataModel listData = CardDataModel();
  bool initialized = false;
  late TextEditingController _nameEdit;

  @override
  void initState() {
    super.initState();
    _nameEdit = TextEditingController();
  }

  List<Item> timeItemsList(LocalStorage file) {
    List<Item> impTimeItems = [...listData.importantItems];
    List<Item> unimpTimeItems = [...listData.unimportantItems];

    impTimeItems.removeWhere((element) {
      return element.time == null;
    });
    unimpTimeItems.removeWhere((element) {
      return element.time == null;
    });
    return [...impTimeItems, ...unimpTimeItems];
  }

  @override
  void dispose() {
    _nameEdit.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LocalStorage storage =
        LocalStorage(widget.time?.toString().split(' ')[0] ?? dataFile);

    return Scaffold(
      appBar: HomeAppBar(storage: storage, list: listData),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topRight,
                colors: [Colors.black, Colors.black87])),
        child: Column(
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height / 5),
              width: MediaQuery.of(context).size.width,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    padding: const EdgeInsets.only(left: 15),
                    child: FutureBuilder(
                        future: nameStorage.ready,
                        builder: (context, snap) {
                          dynamic userName = nameStorage.getItem('username');
                          if (snap.data == null) {
                            return const CircularProgressIndicator();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hello $userName",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text("What are we doing today?",
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                            ],
                          );
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                    backgroundColor: Colors.black,
                                    actions: [
                                      TextField(
                                        autofocus: true,
                                        decoration: const InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: terColor),
                                            ),
                                            label: Text(
                                              'Enter your new name',
                                              style:
                                                  TextStyle(color: mainColor),
                                            )),
                                        controller: _nameEdit,
                                        onSubmitted: (newName) {
                                          nameStorage.setItem(
                                              'username', newName);
                                          _nameEdit.clear();
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ])),
                        customBorder: const CircleBorder(),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: storage.ready,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                listData.importantItems;

                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!initialized) {
                  var impItems = storage.getItem('important');
                  var unimpItems = storage.getItem('unimportant');

                  if (impItems != null) {
                    listData.importantItems = List<Item>.from(
                      (impItems as List).map(
                        (item) => Item(
                          taskId: item['taskId'],
                          taskText: item['taskText'],
                          completed: item['completed'],
                          taskType: item['taskType'],
                          time: DateTime.parse(item['time']),
                        ),
                      ),
                    );
                  }

                  if (unimpItems != null) {
                    listData.unimportantItems = List<Item>.from(
                      (unimpItems as List).map(
                        (item) => Item(
                          taskId: item['taskId'],
                          taskText: item['taskText'],
                          completed: item['completed'],
                          taskType: item['taskType'],
                          time: DateTime.parse(item['time']),
                        ),
                      ),
                    );
                  }
                  initialized = true;
                }

                List<Item> list = timeItemsList(storage);

                for (var item in list) {
                  if (!item.notiState && item.time!.isAfter(DateTime.now())) {
                    NotificationApi.showScheduleNoti(
                      title: "Task due",
                      message:
                          "You have a task thats due at ${convertHour(item)} (in 30 minutes).",
                      scheduleTime:
                          item.time!.subtract(const Duration(minutes: 30)),
                      payload: item.time!.toString(),
                    );

                    item.notiState = true;
                  }
                }

                return Expanded(
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CardWidget(
                            storage: storage,
                            cardColorParam: mainColor,
                            heroTag: "important",
                            items: listData.importantItems,
                            list: listData,
                          ),
                          const SizedBox(
                            height: 55,
                          ),
                          CardWidget(
                            storage: storage,
                            cardColorParam: secColor,
                            heroTag: "unimportant",
                            items: listData.unimportantItems,
                            list: listData,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          // TOD: Change to GetX
                          Navigator.of(context).push(
                            HeroDialogRoute(
                                builder: (context) => Center(
                                      child: TimeModel(
                                        id: "time",
                                        timeColor: terColor,
                                        timeItems: timeItemsList(storage),
                                      ),
                                    )),
                          );
                        },
                        child: SingleChildScrollView(
                          child: SafeArea(
                            child: Hero(
                              tag: "time",
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      height:
                                          (MediaQuery.of(context).size.height) /
                                              2,
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: terColor,
                                      ),
                                      child: SizedBox(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: ListView.builder(
                                            itemCount: 24,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return HourWidget(
                                                items: timeItemsList(storage),
                                                hour: index,
                                                txtBgColor: terColor,
                                              );
                                            },
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      resizeToAvoidBottomInset: false,
    );
  }

  String convertHour(Item item) {
    int hour = item.time!.hour;
    bool daytime = item.time!.hour <= 12;
    String minute = item.time.toString().split(':')[1];
    if (daytime) {
      return '${hour == 0 ? 12 : (hour.toString().length < 2 ? '0$hour' : hour)}:$minute am';
    } else {
      int pmHour = hour - 12;
      return '${pmHour == 0 ? 12 : pmHour.toString().length < 2 ? '0$pmHour' : pmHour}:$minute pm';
    }
  }
}

// ignore: slash_for_doc_comments
/**
 * 
 * * Params to handle / differences between cards:
 * * Color [cardColor]
 * * Item ItemData]
 */

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.storage,
    required this.cardColorParam,
    required this.heroTag,
    required this.items,
    required this.list,
  }) : super(key: key);

  final LocalStorage storage;
  final Color cardColorParam;
  final String heroTag;
  final List<Item> items;
  final CardDataModel list;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TOD: Change to GetX
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: CardModel(
                id: heroTag,
                cardColor: cardColorParam,
                items: items,
                storage: storage,
                list: list,
              ),
            ),
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          height: 175,
          width: (MediaQuery.of(context).size.width / 2) - 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: cardColorParam,
          ),
          child: FutureBuilder(
              future: storage.ready,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: (() {
                    if (items.isNotEmpty) {
                      return ListView.builder(
                        itemCount: items.length,
                        shrinkWrap: false,
                        itemBuilder: (BuildContext context, int index) {
                          return CardDataWidget(
                            index: index,
                            editingActive: false,
                            items: items,
                            storage: storage,
                            id: heroTag,
                            list: list,
                            cardColor: mainColor,
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: DefaultTextStyle(
                          style: TextStyle(fontSize: 16),
                          child: Text(
                            'There are no tasks yet.\nAdd a task!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  }()),
                );
              }),
        ),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({
    required this.list,
    Key? key,
    required this.storage,
  }) : super(key: key);

  final LocalStorage storage;
  final CardDataModel list;

  @override
  Widget build(BuildContext context) {
    List<Item> impTimeItems = [...list.importantItems];
    List<Item> unimpTimeItems = [...list.unimportantItems];

    impTimeItems.removeWhere((element) {
      return element.time == null;
    });
    unimpTimeItems.removeWhere((element) {
      return element.time == null;
    });
    List<Item?> allTimeItems = [...impTimeItems, ...unimpTimeItems];
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        child: Hero(
          tag: "addButton",
          child: ShaderMask(
            shaderCallback: ((bounds) => const LinearGradient(
                  colors: [Colors.red, Colors.yellow],
                ).createShader(bounds)),
            child: const Icon(
              Icons.add_circle,
              size: 40,
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            HeroDialogRoute(
              builder: ((context) => Center(
                    child: AddNewCardButton(
                      storage: storage,
                      list: list,
                      timeItems: allTimeItems,
                    ),
                  )),
            ),
          );
        },
      ),
      actions: [
        InkWell(
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Warning!',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: const Text(
                      '''You're about to delete all your tasks!\n\nAre you sure you want to proceed?'''),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        storage.clear();
                        list.clear();
                        Navigator.of(context).pop();
                        Navigator.of(context).popAndPushNamed('/home');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                  backgroundColor: Colors.black,
                );
              },
            );
          },
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.red, Colors.yellow],
            ).createShader(bounds),
            child: const Icon(
              Icons.delete,
              size: 40,
            ),
          ),
        )
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required WidgetBuilder builder,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}
