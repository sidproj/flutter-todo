import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:helloworld/components/task_widget.dart';

class TaskView extends StatefulWidget {
  final jwt;
  final void Function(String) setUserJwt;
  const TaskView({super.key, required this.jwt, required this.setUserJwt});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  TasksResponse? _taskData;
  late final TextEditingController _task;
  Profile? _profile;
  bool completed = false;

  @override
  void initState() {
    super.initState();
    _task = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getTaskData();
      getProfile();
    });
  }

  void updateTask(final newData) {
    setState(() {
      _taskData = newData;
    });
  }

  void updateProfile(final newProfile) {
    setState(() {
      _profile = newProfile;
    });
  }

  void changeCompleted(bool newCompleted) {
    setState(() {
      completed = newCompleted;
    });
  }

  void getProfile() async {
    final response =
        await http.post(Uri.parse("http://10.200.2.40:3100/profile"),
            headers: <String, String>{
              'Content-Type': "application/json",
            },
            body: jsonEncode(<String, String>{"jwt": widget.jwt}));
    setState(() {
      _profile = Profile.fromJson(jsonDecode(response.body));
    });
  }

  void getTaskData() async {
    final response = await http.post(Uri.parse("http://10.200.2.40:3100/tasks"),
        headers: <String, String>{
          'Content-Type': "application/json",
        },
        body: jsonEncode(<String, String>{"jwt": widget.jwt}));
    final body = TasksResponse.fromJson(jsonDecode(response.body));
    updateTask(body);
    displayTasks();
  }

  String profileEmail() {
    return _profile?.emailID ?? "Unkwown";
  }

  String fullName() {
    return _profile?.fullname ?? "Foo Bar";
  }

  void handleAddTask() async {
    final response =
        await http.post(Uri.parse("http://10.200.2.40:3100/addTask"),
            headers: <String, String>{
              'Content-Type': "application/json",
            },
            body: jsonEncode(<String, String>{
              "jwt": widget.jwt,
              "task_name": _task.text,
            }));
    print(jsonDecode(response.body));
    getTaskData();
  }

  void showAddModal() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'New Task',
                    style: TextStyle(
                        color: Color.fromRGBO(76, 175, 80, 1), fontSize: 20),
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
                      controller: _task,
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
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        completed
                            ? const Color.fromRGBO(51, 51, 51, 1)
                            : const Color.fromRGBO(76, 175, 80, 1),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      handleAddTask();
                      _task.text = "";
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> displayTasks() {
    if (_taskData == null) {
      return [];
    }
    List<Widget> renderText = [];
    for (Task task in _taskData?.tasks ?? []) {
      if (task.isCompleted == completed) {
        renderText.add(HandleTask(
            taskName: task.name,
            id: task.id,
            isCompleted: completed,
            getTasks: getTaskData,
            jwt: widget.jwt));
      }
    }
    if (renderText.isEmpty) {
      String complete = completed ? "Completed" : "Pending";
      renderText.add(
        Center(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Text(
                "No $complete Tasks!",
                style: const TextStyle(
                  color: Color.fromRGBO(76, 175, 80, 1),
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return renderText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
      appBar: AppBar(
        title: const Text("Tasks"),
        backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(51, 51, 51, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileEmail(),
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Text(
                    fullName(),
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                'Log Out',
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                widget.setUserJwt("");
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                bottom: 10.0,
                left: 10.0,
                right: 10.0,
                top: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      changeCompleted(false);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        completed
                            ? const Color.fromRGBO(51, 51, 51, 1)
                            : const Color.fromRGBO(76, 175, 80, 1),
                      ),
                    ),
                    child: const Text(
                      "Pending",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      changeCompleted(true);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        completed
                            ? const Color.fromRGBO(76, 175, 80, 1)
                            : const Color.fromRGBO(51, 51, 51, 1),
                      ),
                    ),
                    child: const Text(
                      "Completed",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 70),
                children: displayTasks(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          showAddModal();
        },
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
            Color.fromRGBO(76, 175, 80, 1),
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class TasksResponse {
  final List<Task>? tasks;

  TasksResponse({this.tasks});

  factory TasksResponse.fromJson(List<dynamic> json) {
    final List<Task> newTasks = [];
    for (var task in json) {
      newTasks.add(Task.fromJson(task));
    }
    return TasksResponse(
      tasks: newTasks,
    );
  }

  void displayTasks() {
    for (var task in tasks ?? []) {
      print(task.name);
    }
  }
}

class Task {
  final name;
  final isCompleted;
  final isDeleted;
  final id;

  Task({this.name, this.isCompleted, this.isDeleted, this.id});

  factory Task.fromJson(dynamic json) {
    return Task(
      name: json['name'],
      isCompleted: json['is_completed'],
      isDeleted: json['is_deleted'],
      id: json['_id'],
    );
  }
}

class Profile {
  final fname;
  final lname;
  final email;
  Profile({this.email, this.fname, this.lname});

  factory Profile.fromJson(dynamic json) {
    return Profile(
      fname: json['fname'],
      email: json['email'],
      lname: json['lname'],
    );
  }

  String get fullname {
    if (fname == null) return "Unkown";
    return fname + " " + lname;
  }

  String get emailID {
    if (email == null) return "Unkown";
    return email;
  }
}
