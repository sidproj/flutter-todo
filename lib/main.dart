import 'package:flutter/material.dart';
import 'package:helloworld/views/login_view.dart';
import 'package:helloworld/views/tasks_view.dart';
import 'package:helloworld/views/register_view.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic jwt;

  void setUserJwt(String jwt) {
    setState(() {
      this.jwt = jwt;
    });
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 61, 117, 178)),
        useMaterial3: true,
        bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Color.fromRGBO(51, 51, 51, 1),
            surfaceTintColor: Color.fromARGB(0, 255, 255, 255)),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Color.fromRGBO(51, 51, 51, 1),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Color.fromRGBO(76, 175, 80, 1),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
      home: LoginView(
        jwt: jwt,
        setUserJwt: setUserJwt,
      ),
      routes: {
        "/login": (context) => LoginView(
              jwt: jwt,
              setUserJwt: setUserJwt,
            ),
        "/register": (context) => RegisterView(),
        "/tasks": (context) => TaskView(
              jwt: jwt,
              setUserJwt: setUserJwt,
            ),
      },
    );
  }
}
