import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HandleTask extends StatefulWidget {
  const HandleTask(
      {Key? key,
      required this.taskName,
      required this.id,
      required this.isCompleted,
      required this.getTasks,
      required this.jwt,
      required this.completed})
      : super(key: key);
  final String taskName;
  final String id;
  final bool isCompleted;
  final jwt;
  final void Function(bool) getTasks;
  final bool completed;

  @override
  State<HandleTask> createState() => _HandleTaskState();
}

class _HandleTaskState extends State<HandleTask> {
  //todo

  void handleTaskDelete() async {
    await http.post(
      Uri.parse("https://todo-backend-cyan.vercel.app/deleteTask"),
      headers: <String, String>{
        'Content-Type': "application/json",
      },
      body: jsonEncode(
        <String, String>{"jwt": widget.jwt, "task_id": widget.id},
      ),
    );
    widget.getTasks(true);
  }

  void handleTaskComplete() async {
    await http.post(
      Uri.parse("https://todo-backend-cyan.vercel.app/changeStatus"),
      headers: <String, String>{
        'Content-Type': "application/json",
      },
      body: jsonEncode(
        <String, dynamic>{
          "jwt": widget.jwt,
          "task_id": widget.id,
          "status": true,
        },
      ),
    );
    widget.getTasks(false);
  }

  Widget handleCompletedDisplay() {
    if (!widget.isCompleted) {
      return ElevatedButton(
        onPressed: () {
          handleTaskComplete();
        },
        style: const ButtonStyle(
          iconColor: MaterialStatePropertyAll<Color>(Colors.white),
          backgroundColor: MaterialStatePropertyAll<Color>(
            Color.fromRGBO(53, 106, 220, 1),
          ),
        ),
        child: const Icon(Icons.task_alt),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Color.fromRGBO(51, 51, 51, 1)),
      padding: const EdgeInsets.only(
        bottom: 10.0,
        left: 15.0,
        right: 15.0,
        top: 10.0,
      ),
      margin: const EdgeInsets.only(
        bottom: 10.0,
        left: 10.0,
        right: 10.0,
        top: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.taskName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.5,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              handleCompletedDisplay(),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  handleTaskDelete();
                },
                style: const ButtonStyle(
                  iconColor: MaterialStatePropertyAll<Color>(Colors.white),
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromRGBO(229, 57, 53, 1),
                  ),
                ),
                child: const Icon(Icons.remove_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
