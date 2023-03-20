import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TextEditingController _controller = TextEditingController();


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
