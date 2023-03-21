import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;
import 'package:html/dom.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _controller = TextEditingController();

  Future<void> hasContactForm(List<String> url) async {
    //create file
    final Directory directory = await getApplicationDocumentsDirectory();
    final File hasFormFile = File('${directory.path}/hasForm.txt');
    final File noFormFile = File('${directory.path}/noForm.txt');
    final File logs = File('${directory.path}/logs.txt');

    for (var i = 0; i < url.length; i++) {
      final response = await http.get(Uri.parse(url[i]));
      if (response.statusCode == 200) {
        final document = parse.parse(response.body);
        final forms = document.querySelectorAll("form");
        bool hasContactForm = false;
        String contactFormUrl = "";
        List<String> formIds = [];
        for (final form in forms) {
          if (form.querySelectorAll("input[type=email]").isNotEmpty ||
              form.querySelectorAll("input[type=submit]").isNotEmpty ||
              form.querySelectorAll("textarea").isNotEmpty) {
            hasContactForm = true;
            String formHtml = form.outerHtml;
            String? actionUrl = form.attributes["action"];
            if (!actionUrl!.startsWith('http')) {
              // If the action URL is a relative URL, append it to the base URL of the website
              actionUrl = url[i] + actionUrl;
            }
            if (!formIds.contains(form.attributes["id"])) {
              // Only add the form URL if we haven't already seen it
              contactFormUrl = actionUrl;
              formIds.add(form.attributes["id"]!);
            }
          }
        }
        if (hasContactForm) {
          hasFormFile.writeAsString(contactFormUrl, mode: FileMode.append);
        } else {
          noFormFile.writeAsString(contactFormUrl, mode: FileMode.append);
        }
      } else {
        logs.writeAsString(url[i], mode: FileMode.append);
      }
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
                  List<String> url = _controller.text.split('\n');
                  await hasContactForm(url);
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
