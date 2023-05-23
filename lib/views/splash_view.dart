import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  final void Function(String) setUserJwt;
  const Splash({super.key, required this.setUserJwt});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late final SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  void _navigateAfterSplash() async {
    prefs = await SharedPreferences.getInstance();
    String? prefsJwt = prefs.getString("jwt");

    await Future.delayed(
      const Duration(milliseconds: 3000),
      () {},
    );
    if (prefsJwt == null || prefsJwt == "") {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } else {
      widget.setUserJwt(prefsJwt);
      Navigator.of(context).pushNamedAndRemoveUntil(
        "/tasks",
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(75, 75, 75, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TODO",
              style: TextStyle(
                  color: Color.fromRGBO(41, 41, 41, 1),
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
