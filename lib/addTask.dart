import 'package:flutter/material.dart';

class TaskExample extends StatefulWidget {
  const TaskExample({super.key});

  @override
  State<TaskExample> createState() => _TaskExampleState();
}

class _TaskExampleState extends State<TaskExample> {
  TextEditingController Task_name = TextEditingController();
  TextEditingController description = TextEditingController();
  bool isChecked = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Task_name",
                      style: TextStyle(fontFamily: "EduTASBeginner"),
                    ),
                  ],
                ),
                TextFormField(
                  controller: Task_name,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "description",
                      style: TextStyle(fontFamily: "EduTASBeginner"),
                    ),
                  ],
                ),
                TextFormField(
                  controller:description,
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontFamily: "EduTASBeginner",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}