import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_genarator/models/password.dart';

class SavedPasswordsPage extends StatefulWidget {
  const SavedPasswordsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SavedPasswordsPageState createState() => _SavedPasswordsPageState();
}

class _SavedPasswordsPageState extends State<SavedPasswordsPage> {
  late Box<Password> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Password>('passwords');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Saved Passwords',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
      ),
      body: ValueListenableBuilder(
        valueListenable: _box.listenable(),
        builder: (context, Box<Password> box, _) {
          final passwords = box.values.toList();
          if (passwords.isEmpty) {
            return const Center(
              child: Text(
                'No saved passwords',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: passwords.length,
            itemBuilder: (context, index) {
              final password = passwords[index];
              return Card(
                color: Colors.amber,
                elevation: 9,
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    password.value!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.copy,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: password.value!));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.amber,
                            content: Center(
                              child: Text(
                                'Password copied to clipboard!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ));
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          size: 30,
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _box.deleteAt(index);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content: Center(
                              child: Text(
                                'Password deleted!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ));
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
