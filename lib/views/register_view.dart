import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _fname;
  late final TextEditingController _lname;
  late final TextEditingController _confPassword;
  int step = 0;
  String error = "";

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confPassword = TextEditingController();
    _fname = TextEditingController();
    _lname = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confPassword.dispose();
    _fname.dispose();
    _lname.dispose();
    super.dispose();
  }

  void testSend() async {
    if (_email.text.replaceAll(' ', '').isEmpty) {
      setState(() {
        error = "Please enter email";
      });
      return;
    }
    if (_password.text.replaceAll(' ', '').isEmpty) {
      setState(() {
        error = "Please enter password";
      });
      return;
    }
    if (_confPassword.text.replaceAll(' ', '').isEmpty) {
      setState(() {
        error = "Please confirm password";
      });
      return;
    }
    setState(() {
      error = "";
    });

    final response = await http.post(
        Uri.parse("https://todo-backend-cyan.vercel.app/register"),
        headers: <String, String>{
          'Content-Type': "application/json",
        },
        body: jsonEncode(<String, String>{
          "first_name": _fname.text,
          "last_name": _lname.text,
          "email": _email.text,
          "password": _password.text,
          "conf_password": _confPassword.text
        }));
    final body = RegisterResponse.fromJson(jsonDecode(response.body));
    print(body.message);
    if (body.message == "Registration Successful") {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } else {
      setState(() {
        error = body.message;
      });
    }
  }

  Widget displayTextFiled() {
    if (step == 0) {
      return (Column(
        children: [
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
              controller: _fname,
              decoration: const InputDecoration(
                  hintText: "Enter First Name",
                  hintStyle: TextStyle(color: Colors.white)),
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
              controller: _lname,
              decoration: const InputDecoration(
                  hintText: "Enter Last Name",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ));
    }
    return (Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
          ),
          child: TextField(
            maxLength: 50,
            style: const TextStyle(color: Colors.white),
            controller: _email,
            decoration: const InputDecoration(
                hintText: "Enter Email",
                hintStyle: TextStyle(color: Colors.white)),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
          ),
          child: TextField(
            maxLength: 50,
            style: const TextStyle(color: Colors.white),
            controller: _password,
            decoration: const InputDecoration(
                hintText: "Enter Password",
                hintStyle: TextStyle(color: Colors.white)),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
          ),
          child: TextField(
            maxLength: 50,
            style: const TextStyle(color: Colors.white),
            controller: _confPassword,
            decoration: const InputDecoration(
                hintText: "Confirm Password",
                hintStyle: TextStyle(color: Colors.white)),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
        ),
      ],
    ));
  }

  Widget displayButtonRow() {
    if (step == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              print(_fname.text);
              print(_lname.text);
              if (_fname.text.replaceAll(' ', '').isEmpty) {
                setState(() {
                  error = "Please enter first name";
                });
                return;
              }
              if (_lname.text.replaceAll(' ', '').isEmpty) {
                setState(() {
                  error = "Please enter last name";
                });
                return;
              }
              setState(() {
                error = "";
                step = 1;
              });
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromRGBO(76, 175, 80, 1)),
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
            child: const Text("Next"),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              step = 0;
            });
          },
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromRGBO(76, 175, 80, 1)),
              foregroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
          child: const Text("Back"),
        ),
        const SizedBox(
          width: 65,
        ),
        TextButton(
          onPressed: testSend,
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromRGBO(76, 175, 80, 1)),
              foregroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
          child: const Text("Register"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
        foregroundColor: Colors.white,
      ),
      body: Center(
          child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              displayTextFiled(),
              !error.isEmpty
                  ? Container(
                      margin: const EdgeInsets.only(
                        bottom: 15.0,
                      ),
                      child: Text(
                        error,
                        style: const TextStyle(
                          color: Color.fromRGBO(229, 57, 53, 1),
                          decoration: TextDecoration.underline,
                          decorationColor: Color.fromRGBO(229, 57, 53, 1),
                          decorationThickness: 2,
                          decorationStyle: TextDecorationStyle.solid,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          displayButtonRow(),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text(
              "Already Registered? Login Here!",
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
