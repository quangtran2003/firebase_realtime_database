import 'package:app_chat_realtime/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

//const apiKey = ...;
void main() async {
  // const apiKey = 'AIzaSyB10JQnQl57aPWbyfyEPg_bj9WXcW8mAtk';

  //   final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  // const prompt = 'what your name?';
  // final content = [Content.text(prompt)];
  // final response = await model.generateContent(content);

  // print(response.text);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Realtime Database',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String realTimeValue = '0';
  String getOnce = '0';

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('title');
    ref.onValue.listen(
      (event) {
        if (event.snapshot.value != null) {
         // setState(() {
            realTimeValue = event.snapshot.value.toString();
          //});
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Realtime Database'),
      ),
      body: Center(
        child: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Icon(Icons.error);
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Real time value: $realTimeValue'),
                  Text('Get Once: $getOnce'),
                  ElevatedButton(
                    onPressed: () async {
                      final snapshot = await ref.get();
                      if (snapshot.exists) {
                        setState(() {
                          getOnce = snapshot.value.toString();
                        });
                      }
                    },
                    child: const Text('Get Once'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
