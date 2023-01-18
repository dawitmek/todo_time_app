import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo_time_app/constant/vars.dart';
import 'package:todo_time_app/models/tasks.dart';
import 'package:todo_time_app/widget/add_button.dart';
import 'package:todo_time_app/widget/hours.dart';
import 'package:todo_time_app/widget/time.dart';
import 'package:todo_time_app/widget/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorage storage = LocalStorage(
    'data${DateTime.now().day.toString()}',
  );
  final CardDataModel listData = CardDataModel();
  bool initialized = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Item> impTimeItems = [...listData.importantItems];
    List<Item> unimpTimeItems = [...listData.importantItems];

    impTimeItems.removeWhere((element) {
      return element.time == null;
    });
    unimpTimeItems.removeWhere((element) {
      return element.time == null;
    });
    List<Item?> allTimeItems = [...impTimeItems, ...unimpTimeItems];

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Hello David",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("What are we doing today?",
                            style: TextStyle(
                              fontSize: 18,
                            )),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Center(
                        child: InkWell(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    )),
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
                        ),
                      ),
                    );
                  }
                  initialized = true;
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
                                        timeItems: allTimeItems,
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
                                                items: allTimeItems,
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
            )
          ],
        ),
      ),
      bottomNavigationBar: const HomeNavigationBar(),
      resizeToAvoidBottomInset: false,
    );
  }
}

// ignore: slash_for_doc_comments
/**
 * TODO: Change the widget to handle actual storage data
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
                  )),
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
                      ListView.builder(
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

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), label: "Date"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedItemColor: mainColor,
      type: BottomNavigationBarType.fixed,
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
                    child: AddNewCardButton(storage: storage, list: list),
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
  /// {@macro hero_dialog_route}
  HeroDialogRoute({
    required WidgetBuilder builder,
    // RouteSettings settings,
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
