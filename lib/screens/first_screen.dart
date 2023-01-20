import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo_time_app/constant/vars.dart';
import 'package:todo_time_app/screens/home.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  LocalStorage nameStorage = LocalStorage(usernameFile);
  late TextEditingController _controller;
  late final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus;
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Hello, let's get started.\nWhat is your name?",
                style: TextStyle(fontSize: 30),
              ),
              TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  focusNode: _focus,
                  decoration: InputDecoration(
                    label: const Text('Enter your name here.'),
                    labelStyle: const TextStyle(color: terColor),
                    errorText: _errText(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                    ),
                  ),
                  onChanged: (String string) {
                    setState(() {});
                  }),
              Builder(builder: (BuildContext context) {
                return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: _controller.text.length > 4
                            ? [mainColor, terColor]
                            : [Colors.grey, Colors.grey],
                      ),
                    ),
                    width: 200,
                    child: InkWell(
                      onTap: () {
                        nameStorage
                            .setItem('username', _controller.text)
                            .then((value) {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                            return const HomeScreen();
                          }, transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                            const begin = Offset(1, 0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                                position: animation.drive(tween), child: child);
                          }));
                        });
                      },
                      splashColor: secColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: _controller.text.length <= 4
                                      ? const CircularProgressIndicator(
                                          strokeWidth: 3, color: mainColor)
                                      : const Icon(Icons.check_circle,
                                          color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              }),
            ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  String? _errText() {
    if (_controller.text.length < 4 && _focus.hasFocus) {
      return 'Name must be more than 4 letters';
    } else {
      return null;
    }
  }
}
