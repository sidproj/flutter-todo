import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  final jwt;
  final void Function(String) setUserJwt;
  const LoginView({super.key, this.jwt, required this.setUserJwt});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  String loginView = "";

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    // loginView = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    // loginView.dispose();
    super.dispose();
  }

  void testSend() async {
    final data = {"email": _email.text, "password": _password.text};
    print(data);

    final response = await http.post(Uri.parse("http://10.200.2.40:3100/login"),
        headers: <String, String>{
          'Content-Type': "application/json",
        },
        body: jsonEncode(<String, String>{
          "email": _email.text,
          "password": _password.text,
        }));
    final body = RegisterResponse.fromJson(jsonDecode(response.body));
    if (body.message == "Login successful!") {
      widget.setUserJwt(body.jwt);
      Navigator.of(context).pushNamedAndRemoveUntil('/tasks', (route) => false);
    } else {
      setState(() {
        loginView = "Incorrect Username or Password";
      });
    }
    print(body.message);
    print(body.jwt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
        foregroundColor: Colors.white,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              bottom: 10.0,
              left: 10.0,
              right: 10.0,
              top: 10.0,
            ),
            child: TextField(
              maxLength: 50,
              style: const TextStyle(color: Colors.white),
              controller: _email,
              decoration: const InputDecoration(
                filled: false,
                fillColor: Color.fromRGBO(76, 175, 80, 1),
                hintText: "Enter Email",
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 10.0,
              left: 10.0,
              right: 10.0,
              top: 10.0,
            ),
            child: TextField(
              maxLength: 50,
              style: const TextStyle(color: Colors.white),
              controller: _password,
              decoration: const InputDecoration(
                filled: false,
                fillColor: Color.fromRGBO(76, 175, 80, 1),
                hintText: "Enter Passowrd",
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                focusColor: Color.fromRGBO(76, 175, 80, 1),
              ),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
          ),
          Text(loginView),
          TextButton(
            onPressed: testSend,
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromRGBO(76, 175, 80, 1)),
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/register', (route) => false);
            },
            child: const Text(
              "Do not have an account? Register Here!",
              style: TextStyle(
                color: Color.fromRGBO(76, 175, 80, 1),
                decoration: TextDecoration.underline,
                decorationColor: Color.fromRGBO(76, 175, 80, 1),
                decorationThickness: 2,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
          )
        ],
      )),
    );
  }
}

//temp class for reciveing response
class RegisterResponse {
  final message;
  final jwt;

  RegisterResponse({this.message, this.jwt});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'],
      jwt: json['jwt'],
    );
  }
}
