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
    'data${DateTime.now().toString().split(' ')[0]}',
  );
  final CardDataModel listData = CardDataModel();

  @override
  Widget build(BuildContext context) {
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
            Expanded(
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
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                      CardWidget(
                        storage: storage,
                        cardColorParam: secColor,
                        heroTag: "unimportant",
                        items: listData.unimportantItems,
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
                            builder: (context) => const Center(
                                  child: TimeModel(
                                    id: "time",
                                    timeColor: terColor,
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
                                      (MediaQuery.of(context).size.height) / 2,
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: terColor,
                                  ),
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: ListView.builder(
                                        itemCount: 24,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return HourWidget(
                                            task: "TEST",
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
  }) : super(key: key);

  final LocalStorage storage;
  final Color cardColorParam;
  final String heroTag;
  final List<Item> items;

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
                      localDatabase: storage,
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
                    child: ListView.builder(
                      itemCount: 5,
                      shrinkWrap: false,
                      itemBuilder: (BuildContext context, int index) {
                        return CardDataWidget(
                          index: index,
                          taskText: "Testing Testing Testing ",
                          editingActive: false,
                          completed: false,
                        );
                      },
                    ));
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
        Container(
            margin: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: Colors.orange.shade600,
            ))
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
