import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TextEditingController _controller = TextEditingController();

  Future<bool> hasContactForm(String websiteUrl) async {
    final response = await http.get(Uri.parse(websiteUrl));
    final document = parser.parse(response.body);
    final forms = document.getElementsByTagName('form');
    return forms.isNotEmpty;
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Result'),
                      content: Text(hasForm ? 'Yes' : 'No'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
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
