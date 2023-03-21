import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _controller = TextEditingController();

  Future<bool> hasContactForm(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final document = parse.parse(response.body);
      final inputElements = document.querySelectorAll(
          'input[name="name"], input[name="email"], input[name="subject"], input[name="message"], input[name="comment"]');
      final formElements =
          document.querySelectorAll('form[action], form[method]');
      return inputElements.isNotEmpty || formElements.isNotEmpty;
    } else {
      throw Exception('Failed to load website');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contact Form Checker'),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(20)),
              Text('Enter a website URL to check if it has a contact form'),
              Padding(padding: EdgeInsets.all(20)),
              SizedBox(
                width: 300,
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Website URL',
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(20)),
              ElevatedButton(
                onPressed: () async {
                  final hasForm = await hasContactForm(_controller.text);
                  print(hasForm);
                },
                child: Text('Check'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
