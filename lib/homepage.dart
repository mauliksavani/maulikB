import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

// String token =
//     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjAzYjUxODZlLTgyZmYtNGNjNi05YTc4LWY2OTM2ZWQ4ZjJkZiIsImlhdCI6MTcwNjA5MDg3NCwiZXhwIjoxNzA2MTc3Mjc0fQ.QL6ofBuDGZbiBvM5wjMEWcXV66q1N1zlZNL3eK2tmzA";

class HomePageExample extends StatefulWidget {
  final dynamic userData;
  final String? documentId;

  const HomePageExample({super.key, this.userData, this.documentId});

  @override
  State<HomePageExample> createState() => _HomePageExampleState();
}

class _HomePageExampleState extends State<HomePageExample> {
  bool isCreateAPiResponse = false;

  @override
  void initState() {
    super.initState();
    getAllTask();
  }

  // bool isChecked = false;
  List responseList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Task"),
          actions: [
            IconButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  prefs.clear();
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPageExample()),
                        (route) => false,
                  );
                },
                icon: Icon(Icons.logout))
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                //  icon: Icon(Icons.circle_outlined),
                child: Text("All"),
              ),
              Tab(
                //  icon: Icon(Icons.pending),
                child: Text("Pending"),
              ),
              Tab(
                //icon: Icon(Icons.circle),
                child: Text("Complete"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: () async {
                print("on refresh");
                getAllTask();
              },
              child: ListView.builder(
                itemCount: responseList.length,
                itemBuilder: (_, i) {
                  return commonCardWidget(i, context);
                },
              ),
            ),
            RefreshIndicator(
              onRefresh: ()async{
                print("on refresh");
                getAllTask();
              },
              child: ListView.builder(
                itemCount: responseList.length,
                itemBuilder: (_, i) {
                  return responseList[i]['status'] != false
                      ? SizedBox()
                      : commonCardWidget(i, context);
                },
              ),
            ),
            RefreshIndicator(
              onRefresh: ()async{
                print("on refresh");
                getAllTask();
              },
              child: ListView.builder(
                itemCount: responseList.length,
                itemBuilder: (_, i) {
                  return responseList[i]['status'] == false
                      ? SizedBox()
                      : commonCardWidget(i, context);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            TextEditingController nameController = TextEditingController();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Add Task"),
                  content: TextFormField(
                    controller: nameController,
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        createTask(nameController.text);
                      },
                      child: Text("Yes"),
                    ),
                  ],
                );
              },
            );
            // getAllTask();
          },
        ),
      ),
    );
  }

  Widget commonCardWidget(int i, BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "Are you sure you want to delete?",
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          deleteAPI(responseList[i]['id']);
                          // Navigator.pop(context);
                        },
                        child: const Text("yes"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      ),
                    ],
                  );
                },
              );
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          edit(responseList[i]);
        },
        child: Row(
          children: [
            Checkbox(
              value: responseList[i]['status'],
              onChanged: (bool? value) {
                setState(() {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          "Are you sure you want to complete your Task?",
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              statusUpdate(responseList[i]);

                              // responseList[i]['status'] = value!;

                              // Navigator.pop(context);
                            },
                            child: const Text("yes"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No"),
                          )
                        ],
                      );
                    },
                  );
                });
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${responseList[i]['description']}"),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(DateFormat("dd MMM, yyyy hh:mm").format(
                          DateTime.parse(
                              responseList[i]['created_at'].toString())))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getAllTask() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString("token");
    print("token -- $token");

    print("call api");
    http.Response response = await http.get(
        Uri.parse(
          "https://todo-list-app-kpdw.onrender.com/api/tasks/",
        ),
        headers: {"x-access-token": "$token"});
    print("response statusCode-getAllTask- ${response.statusCode}");
    print("response body-- ${response.body}");
    //  Navigator.pop(context);
    if (response.statusCode == 200) {
      responseList = jsonDecode(response.body);
      setState(() {});
      // success
    } else {
      // error
    }
  }


  void createTask(String name) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString("token");
    print("call createTask api");
    http.Response response = await http.post(
        Uri.parse(
          "https://todo-list-app-kpdw.onrender.com/api/tasks",
        ),
        body: {"description": name, "status": "false"},
        headers: {"x-access-token": "$token"});
    print("response statusCode-- ${response.statusCode}");
    print("response body-- ${response.body}");
    Navigator.pop(context);
    if (response.statusCode == 200) {
      getAllTask();
      Fluttertoast.showToast(
        msg: "Task Add successfully",
        gravity: ToastGravity.BOTTOM,
      );

      Navigator.pop(context);
      // responseList = jsonDecode(response.body);
      // setState(() {});
      // success
    } else {
      // error
    }
  }

  void updateTask(String name, id) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("call updateTask api");
    http.Response response = await http.put(
        Uri.parse(
          "https://todo-list-app-kpdw.onrender.com/api/tasks/$id",
        ),
        body: {"description": name, "status": "false"},
        headers: {"x-access-token": "$token"});
    print("response statusCode-- ${response.statusCode}");
    print("response body-- ${response.body}");
    Navigator.pop(context);
    if (response.statusCode == 200) {
      getAllTask();
      Fluttertoast.showToast(
        msg: "Task update successfully",
        gravity: ToastGravity.BOTTOM,
      );
      isCreateAPiResponse == true
          ? const Center(child: CircularProgressIndicator())
          : Navigator.pop(context);
      // responseList = jsonDecode(response.body);
      // setState(() {});
      // success
    } else {
      // error
    }
  }

  void deleteAPI(id) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    print("call delete api");
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString("token");
    http.Response response = await http.delete(
        Uri.parse(
          "https://todo-list-app-kpdw.onrender.com/api/tasks/$id",
        ),
        headers: {"x-access-token": "$token"});
    print("response statusCode-- ${response.statusCode}");
    print("response body-- ${response.body}");
    Navigator.pop(context);
    if (response.statusCode == 200) {
      getAllTask();
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Task delete successfully",
        gravity: ToastGravity.BOTTOM,
      );

      // responseList = jsonDecode(response.body);
      // setState(() {});
      // success
    } else {
      // error
    }
  }

  void statusUpdate(id) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    print("call delete api");
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString("token");
    http.Response response = await http.put(
        Uri.parse(
          "https://todo-list-app-kpdw.onrender.com/api/tasks/${id['id']}",
        ),
        headers: {"x-access-token": "$token"},
        body: {"description": "${id['description']}", "status": "true"});
    print("response statusCode-- ${response.statusCode}");
    print("response body-- ${response.body}");
    Navigator.pop(context);
    if (response.statusCode == 200) {
      getAllTask();
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Task update successfully",
        gravity: ToastGravity.BOTTOM,
      );

      // responseList = jsonDecode(response.body);
      // setState(() {});
      // success
    } else {
      // error
    }
  }

  void edit(res) {
    TextEditingController editController = TextEditingController();
    editController.text = res['description'];
    bool light0 = true;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextFormField(
            controller: editController,
          ),
          title: Text("edit your task"),
          actions: [
            Switch(
              value: light0,
              onChanged: (bool value) {
                setState(() {
                  light0 = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                updateTask(editController.text, res['id']);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
