import 'dart:ui';

import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/core/db/db_helper.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../../../main.dart';

class ToDoScreen extends StatefulWidget {
  ToDoScreen({Key? key}) : super(key: key);

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> with WidgetsBindingObserver {
  AppLifecycleState? appLifecycleState;
  final list = [];
  @override
  void initState() {
    super.initState();
    final dbHelper = DBHelper();
    WidgetsBinding.instance.addObserver(this);
    dbHelper.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      appLifecycleState = state;
      print('=========>>');
      print(appLifecycleState);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController todoController = TextEditingController();
    return FutureBuilder<dynamic>(
      future: dbHelper.queryAllRows(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> data = snapshot.data ?? [];
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              toolbarHeight: 75,
              backgroundColor: Colors.cyan.withOpacity(.6),
              title: Row(
                children: [
                  const Text("To-Do"),
                  const SizedBox(
                      width:
                          16), // Adjust the spacing between text and text field
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white.withOpacity(.6),
                        filled: true,
                        hintText: 'Search...',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: WidgetAnimator(
              incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(
                  delay: const Duration(seconds: 1), opacity: .5),
              atRestEffect: WidgetRestingEffects.size(),
              child: FloatingActionButton(
                isExtended: true,
                focusColor: Colors.black,
                focusElevation: 50.0,
                backgroundColor: Colors.cyan.withOpacity(.6),
                onPressed: () {
                  var x = [1];
                  var y = [2, 3];
                  x = [1, 2, ...y];
                  var r = r'$100';
                  print(r);
                  Get.dialog(
                    barrierDismissible: true,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Material(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Today's Todo",
                                      textAlign: TextAlign.center,
                                    ),
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller: titleController,
                                          maxLines: 1,
                                          decoration: const InputDecoration(
                                              labelText: 'Title'),
                                        ),
                                        TextFormField(
                                          controller: todoController,
                                          decoration: const InputDecoration(
                                              labelText: 'Todo'),
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 25),
                                      ],
                                    ),
                                    //Buttons
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(0, 45),
                                              primary:
                                                  Colors.cyan.withOpacity(.6),
                                              onPrimary:
                                                  const Color(0xFFFFFFFF),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text(
                                              'Cancel',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(0, 45),
                                              primary:
                                                  Colors.cyan.withOpacity(.6),
                                              onPrimary:
                                                  const Color(0xFFFFFFFF),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              dbHelper.insert(
                                                  titleController?.text,
                                                  todoController!.text,
                                                  Uuid().v4());
                                              setState(() {});
                                              Get.back();
                                            },
                                            child: const Text(
                                              'Add',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        ],
                    ),
                  );
                },
                child: ClipRect(
                  child: BackdropFilter(filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0
                  ),
                  child: Icon(Icons.add)),
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var item = data[index];
                return Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 95,
                      height: 100,
                      margin:
                          const EdgeInsets.only(left: 10, top: 10, right: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.cyan.withOpacity(.39),
                          border: Border.all(color: Colors.white24, width: 2)),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              item['todoTitle'].toString(),
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              item['todo'].toString(),
                              maxLines: 2,
                            ),
                            // Add more widgets as needed
                          ),
                          Text(item['uuid'].toString())
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 68,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.amber.withOpacity(.8),
                      ),
                      margin:
                          const EdgeInsets.only(right: 8, top: 10, bottom: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                              onPressed: () {
                                Get.dialog(
                                  barrierDismissible: true,
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Material(
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                    "Edit your todo",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Column(
                                                    children: [
                                                      TextFormField(
                                                        controller:
                                                            titleController,
                                                        maxLines: 1,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Title'),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Empty Field';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            todoController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Todo'),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Empty Field';
                                                          }
                                                          return null;
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: 1,
                                                      ),
                                                      const SizedBox(
                                                          height: 25),
                                                    ],
                                                  ),
                                                  //Buttons
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            minimumSize:
                                                                const Size(
                                                                    0, 45),
                                                            primary: Colors.cyan
                                                                .withOpacity(
                                                                    .6),
                                                            onPrimary:
                                                                const Color(
                                                                    0xFFFFFFFF),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            var id =
                                                                Uuid().v6();
                                                            print(id);
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            minimumSize:
                                                                const Size(
                                                                    0, 45),
                                                            primary: Colors.cyan
                                                                .withOpacity(
                                                                    .6),
                                                            onPrimary:
                                                                const Color(
                                                                    0xFFFFFFFF),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            dbHelper.update(
                                                              item['todoId'],
                                                              titleController
                                                                  ?.text,
                                                              todoController!
                                                                  .text,
                                                            );
                                                            setState(() {});
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            'Add',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text('Edit')),
                          TextButton(
                              onPressed: () {
                                Get.dialog(
                                  barrierDismissible: true,
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Material(
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 10),
                                                  const SizedBox(height: 15),
                                                  const Text(
                                                    "Are you sure?",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 20),
                                                  //Buttons
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            minimumSize:
                                                                const Size(
                                                                    0, 45),
                                                            primary: Colors.cyan
                                                                .withOpacity(
                                                                    .7),
                                                            onPrimary:
                                                                const Color(
                                                                    0xFFFFFFFF),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            'No',
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            minimumSize:
                                                                const Size(
                                                                    0, 45),
                                                            primary:
                                                                Colors.amber,
                                                            onPrimary:
                                                                const Color(
                                                                    0xFFFFFFFF),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            dbHelper.delete(
                                                                item['todoId']);
                                                            setState(() {});
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            'Yes',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text('Delete')),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
