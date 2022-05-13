import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume - Flutter',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      // home: const MyHomePage(title: 'Resume - Flutter'),
      home: const ResumePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(
                fontSize: 28,
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              '$_counter',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: FloatingActionButton(
              onPressed: _decrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.remove),
            ),
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class IndexResponse {
  final String appName;
  final String version;
  final String stack;
  final String url;

  const IndexResponse({
    required this.appName,
    required this.version,
    required this.stack,
    required this.url,
  });

  factory IndexResponse.fromJson(Map<String, dynamic> json) {
    return IndexResponse(
      appName: json['appName'] as String,
      version: json['version'] as String,
      stack: json['stack'] as String,
      url: json['url'] as String,
    );
  }
}

class ResumePage extends StatefulWidget {
  const ResumePage({Key? key}) : super(key: key);

  final String url = 'https://fiber.odellmay.com';

  Future<IndexResponse> getIndex() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return IndexResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load index response');
    }
  }

  String get title => 'flutter.odellmay.com';

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  late Future<IndexResponse> _indexResponse;

  @override
  void initState() {
    super.initState();
    _indexResponse = widget.getIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<IndexResponse>(
              future: _indexResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(
                        snapshot.data!.appName,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        snapshot.data!.version,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Text(
                        snapshot.data!.stack,
                        style: const TextStyle(
                          fontSize: 22,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 22, 0, 0),
                        child: Text(
                          snapshot.data!.url,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return const CircularProgressIndicator();
              },
            ),
          ],
        )));
  }
}
