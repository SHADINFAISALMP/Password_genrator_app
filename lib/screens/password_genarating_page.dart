import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:password_genarator/models/password.dart';
import 'dart:math';
import 'package:password_genarator/screens/saved_passwords.dart';

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordGeneratorPageState createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  final _random = Random();
  String _generatedPassword = '';
  final _box = Hive.box<Password>('passwords');

  int _passwordLength = 12;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSpecialChars = true;

  String _generatePassword(int length) {
    const upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const specialChars = '!@#\$%^&*()';
    String chars = '';

    if (_includeUppercase) chars += upperCaseLetters;
    if (_includeLowercase) chars += lowerCaseLetters;
    if (_includeNumbers) chars += numbers;
    if (_includeSpecialChars) chars += specialChars;

    if (chars.isEmpty) return '';

    return List.generate(
        length, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  void _savePassword() {
    if (_generatedPassword.isNotEmpty) {
      final newPassword = Password(_generatedPassword);
      _box.add(newPassword);
      print("password save to hive $_generatedPassword");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.amber,
        content: Center(
            child: Text(
          'Password saved!',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )),
      ));
    }
  }

  void _copyToClipboard() {
    if (_generatedPassword.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedPassword));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.amber,
        content: Center(
            child: Text(
          'Password copied to clipboard!',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )),
      ));
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Center(
        child: Text(
          message,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text(
          'Password Generator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password Length: $_passwordLength',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Slider(
                activeColor: Colors.amber,
                thumbColor: Colors.black,
                value: _passwordLength.toDouble(),
                min: 6,
                max: 30,
                divisions: 28,
                label: _passwordLength.toString(),
                onChanged: (double value) {
                  setState(() {
                    _passwordLength = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSwitch('Include Numbers', _includeNumbers, (value) {
                setState(() {
                  _includeNumbers = value;
                });
              }),
              _buildSwitch('Include Uppercase Letters', _includeUppercase,
                  (value) {
                setState(() {
                  _includeUppercase = value;
                });
              }),
              _buildSwitch('Include Lowercase Letters', _includeLowercase,
                  (value) {
                setState(() {
                  _includeLowercase = value;
                });
              }),
              _buildSwitch('Include Special Characters', _includeSpecialChars,
                  (value) {
                setState(() {
                  _includeSpecialChars = value;
                });
              }),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 18),
                  ),
                  onPressed: () {
                    if (!_includeUppercase &&
                        !_includeLowercase &&
                        !_includeNumbers &&
                        !_includeSpecialChars) {
                      _showSnackbar(
                          'Please select at least one character type.');
                    } else {
                      setState(() {
                        _generatedPassword = _generatePassword(_passwordLength);
                      });
                    }
                  },
                  child: const Text(
                    'Generate Password',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_generatedPassword.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    _generatedPassword,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 18),
                    ),
                    onPressed:
                        _generatedPassword.isNotEmpty ? _savePassword : null,
                    child: const Text(
                      'Save Password',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 18),
                    ),
                    onPressed:
                        _generatedPassword.isNotEmpty ? _copyToClipboard : null,
                    child: const Text(
                      'Copy to Clipboard',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedPasswordsPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'View Saved Passwords',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Switch(
            inactiveThumbColor: Colors.black,
            activeTrackColor: Colors.amber,
            value: value,
            onChanged: onChanged,
            activeColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
