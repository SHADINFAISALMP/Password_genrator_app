import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:password_genarator/models/password.dart';

class SavedPasswordsPage extends StatefulWidget {
  const SavedPasswordsPage({super.key});

  @override
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
              child: Text('No saved passwords'),
            );
          }

          return ListView.builder(
            itemCount: passwords.length,
            itemBuilder: (context, index) {
              final password = passwords[index];
              return ListTile(
                title: Text(password.value!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: password.value!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password copied to clipboard!'),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _box.deleteAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password deleted!'),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
