import 'package:get/get.dart';
import 'package:todo/core/db/db_helper.dart';

import '../todo_model/todo_model.dart';

class ToDoController extends GetxController{
  RxList<Todo> todos = <Todo>[].obs;
  RxBool isLoading = false.obs;
  final dbHelper = DBHelper();
  RxList<Todo> results = <Todo>[].obs;
  @override
  void onInIt() async {
    isLoading.toggle();
    final data = await DBHelper().fetchWordsFromDB();
    data.forEach((item){
      final element = Todo.fromJson(item);
      todos.add(element);
      print(todos);
    });
    super.onInit();
    isLoading = false.obs;

  }

  void filter_Todo(String todo) {

    if(todo.isEmpty){
      results(todos);
    }
    else {
      results(todos.where((p0) => p0.title.toString().toLowerCase().contains(todo.toLowerCase())).toList());
    }
  }


  Future<void> addTodo(String? title, String? todo, String? uuid) async {
    await dbHelper.insert(title, todo, uuid);
  }

  Future<void> updateTodo(int? id,String? title, String? todo) async {
    await dbHelper.update(id, title, todo);
  }

  Future<void> queryAll(int id,String title, String todo) async {
    todos = await dbHelper.queryAllRows() as RxList<Todo>;
  }

  Future<void> deleteTodo(int? id) async {
    await dbHelper.delete(id ?? 0);
  }
}