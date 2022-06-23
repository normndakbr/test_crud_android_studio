import 'dart:convert';
import '../models/todos.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  final String baseUrl = "https://jsonplaceholder.typicode.com/";
  Client client = Client();

  Future<List<Todos>> getTodos() async {
    // "https://jsonplaceholder.typicode.com/todos/"
    Uri url = Uri.parse(baseUrl + 'todos/');

    final response = await client.get(url);
    print("Response Status Code = " + response.statusCode.toString());
    // print("Response body = " + response.body);
    if (response.statusCode == 200) {
      return todosFromJson(response.body);
    } else {
      print("Fetch data failed!");
      return [];
    }
  }

  Future<Todos?> getTodosById(String id) async {
    Uri url = Uri.parse(baseUrl + 'todos/$id');

    final response = await client.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> parsed = json.decode(response.body);
      return Todos.fromJson(parsed);
    } else {
      print("Error fetch data");
      return null;
    }
  }

  Future<bool> createTodos(
      String newUserId, String newTitle, String newCompleted) async {
    Uri url = Uri.parse(baseUrl + 'todos/');
    final response = await client.post(
      url,
      headers: {
        "Content-type": "application/json; charset=UTF-8",
      },
      body: jsonEncode({
        'userId': newUserId,
        'title': newTitle,
        'completed': newCompleted,
      }),
    );
    if (response.statusCode == 201) {
      print("Create Data Success!");
      print(response.body);
      return true;
    } else {
      print("Create Data Failed!");
      print(response.body);
      return false;
    }
  }

  Future<bool> editTodos(
      String id, String newUserId, String newTitle, String newCompleted) async {
    Uri url = Uri.parse(baseUrl + 'todos/$id');

    final response = await client.put(
      url,
      headers: {
        "Content-type": "application/json; charset=UTF-8",
      },
      body: jsonEncode({
        'userId': newUserId,
        'title': newTitle,
        'completed': newCompleted,
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteTodos(String id) async {
    Uri url = Uri.parse(baseUrl + 'todos/$id');

    final response = await client.delete(url);

    print(response.statusCode);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
