import 'package:flutter/material.dart';
import 'sql_helper.dart';
// Import model dan repository (controller) todos
import 'repositories/todos.dart';
import 'models/todos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Classic.notes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // deklarasi variabel untuk model Todo
  late Todos todosData;

  // deklarasi variabel dalam bentuk list untuk menampung list data dari Todo
  List<Todos> todoList = [];

  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  void _refreshJournals() async {
    // Request ke API service
    ApiService().getTodos().then((response) => {
          setState(() {
            for (var i = 0; i < response.length; i++) {
              // Lakukan perulangan sejumlah data balikan response, lalu masukkan data ke-i ke dalam list data Todo
              todoList.add(Todos(
                userId: response[i].userId,
                id: response[i].id,
                title: response[i].title,
                completed: response[i].completed,
              ));
            }
            // set variabel _isLoading menjadi false
            _isLoading = false;
          })
        });
  }

  createData(String newUserId, String newTitle, String newStatus) {
    // Lakukan request createTodos pada API Service
    ApiService().createTodos(newUserId, newTitle, newStatus).then((response) {
      if (response == true) {
        // jika response berhasil (true), maka tampilkan snackbar berikut
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note added successfully!'),
          ),
        );
      } else {
        // jika response gagal (false), maka tampilkan snackbar berikut
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Create request failed, please kindly check your internet connection.'),
          ),
        );
      }
    });
  }

  getTodosById(String id) async {
    // Lakukan Request getTodosById pada API Service
    await ApiService().getTodosById(id).then((response) {
      if (response != null) {
        // set data response ke dalam todosData
        todosData = response;

        // Lakukan set state pada state _titleController.text dan _descriptionController.text
        setState(() {
          _titleController.text = 'Note ' + todosData.id;
          _descriptionController.text = todosData.title;
        });
      } else {
        print("No Data!");
      }
    });
  }

  editTodos(String id, String newUserId, String newTitle, String newCompleted) {
    // Lakukan request editTodos pada API Service
    ApiService()
        .editTodos(id, newUserId, newTitle, newCompleted)
        .then((response) {
      if (response == true) {
        // jika response berhasil (true), maka tampilkan snackbar berikut
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note ' + id + ' has editted successfully!')),
        );
      } else {
        // jika response gagal (false), maka tampilkan snackbar berikut
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Edit request failed, please kindly check your internet connection.'),
          ),
        );

        print(response);
      }
    });
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    } else {
      _titleController.text = '';
      _descriptionController.text = '';
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Judul'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Deskripsi'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new journal
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _titleController.text = '';
                      _descriptionController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Tambah Baru' : 'Perbarui'),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classic.notes'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_journals[index]['title']),
                  subtitle: Text(_journals[index]['description']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showForm(_journals[index]['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(_journals[index]['id']),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
