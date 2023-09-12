import 'package:flutter/material.dart';
import 'package:testing_image_cache/image_cache.dart';

import 'db_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static String image =
      "https://media.gq-magazine.co.uk/photos/64958a59e94077a23fe18301/1:1/w_1440,h_1440,c_limit/avatar-1.jpg";
  static String image1 =
      "https://cdn.footballghana.com/2020/12/5fd39e24023ce.jpg";
  static String image2 =
      "https://media.gq-magazine.co.uk/photos/64958a59e94077a23fe18301/1:1/w_1440,h_1440,c_limit/avatar-1.jpg";

  void _incrementCounter() {
    DatabaseService.deleteCacheImage();
  }

  List<String> images = [image1, image, image];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Image.network(image1),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var item in images) ImageCacheNetwork(imageUrl: item),
                ],
              ),
            )),
            Text(
              '${DatabaseService.getCacheSize()}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
