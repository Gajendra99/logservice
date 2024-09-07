import 'package:example/Widgets/log_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_log_service/Models/log_status.dart';
import 'package:flutter_log_service/flutter_log_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  FlutterLogService logService = FlutterLogService();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    logService.initLogFile();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LogService',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Log Service',
        logService: logService,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.logService});
  final FlutterLogService logService;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? nullString;

  void generateNullError() async {
    try {
      print(nullString!
          .length); // Will throw an error because of forced null access
    } catch (e) {
      LogStatus status = await widget.logService.setLog(
          errorTitle: "Undefined Error",
          errorMessage: "$e",
          level: LogLevel.WARNING);
      print("${status.status}-------str----${status.msg}");
    }
  }

  void generateDivisionByZeroError() async {
    try {
      int result = 10 ~/ 0; // Integer division by zero
    } catch (e) {
      LogStatus status = await widget.logService.setLog(
          errorTitle: "Undefined Error",
          errorMessage: "$e",
          level: LogLevel.ERROR);
      print("${status.status}-------str----${status.msg}");
    }
  }

  void generateIndexOutOfBoundsError() async {
    try {
      List<int> numbers = [1, 2, 3];
      print(numbers[5]); // Will throw an error as index 5 doesn't exist
    } catch (e) {
      LogStatus status = await widget.logService.setLog(
          errorTitle: "Undefined Error",
          errorMessage: "$e",
          level: LogLevel.WARNING);
      print("${status.status}-------str----${status.msg}");
    }
  }

  void generateTypeError() async {
    try {
      dynamic value = "Hello";
      int number = value as int; // Will throw a type error
    } catch (e) {
      LogStatus status = await widget.logService.setLog(
          errorTitle: "Undefined Error",
          errorMessage: "$e",
          level: LogLevel.INFO);
      print("${status.status}-------str----${status.msg}");
    }
  }

  void generateManualException() async {
    try {
      throw Exception("Manually generated error");
    } catch (e) {
      LogStatus status = await widget.logService.setLog(
          errorTitle: "Undefined Error",
          errorMessage: "$e",
          level: LogLevel.ERROR);
      print("${status.status}-------str----${status.msg}");
    }
  }

  void shareLogFile() async {
    LogStatus status = await widget.logService.shareLog();
    print("${status.status}-----------${status.msg}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LogsView(logService: widget.logService),
                  ),
                );
              },
              icon: Icon(Icons.list_alt))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            generateButton(
                title: "Generate Null Error", callback: generateNullError),
            generateButton(
                title: "Generate Divide By Zero",
                callback: generateDivisionByZeroError),
            generateButton(
                title: "Generate Index Out of Bounds",
                callback: generateIndexOutOfBoundsError),
            generateButton(
                title: "Generate Type Error", callback: generateTypeError),
            generateButton(
                title: "Generate Manual Exception",
                callback: generateManualException),
            generateButton(title: "Share File", callback: shareLogFile),
          ],
        ),
      ),
    );
  }

  Widget generateButton({required String title, required Function() callback}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: Colors.black)),
          child: Text("$title")),
    );
  }
}
