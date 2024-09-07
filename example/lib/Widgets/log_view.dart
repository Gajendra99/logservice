import 'package:flutter/material.dart';
import 'package:flutter_log_service/Models/log_data.dart';
import 'package:flutter_log_service/flutter_log_service.dart';
import 'package:intl/intl.dart';

class LogsView extends StatefulWidget {
  final FlutterLogService logService;
  const LogsView({Key? key, required this.logService}) : super(key: key);

  @override
  _LogsViewState createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  late Future<List<LogData>> _futureLogs;

  @override
  void initState() {
    super.initState();
    // Fetch logs initially when screen is built
    _futureLogs = widget.logService.getFilteredLogs(
      logLevel: null,
      startDate: DateTime.now().subtract(Duration(hours: 4)),
      endDate: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filtered Logs"),
      ),
      body: FutureBuilder<List<LogData>>(
        future: _futureLogs,
        builder: (BuildContext context, AsyncSnapshot<List<LogData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            ); // Show error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No logs found')); // Show if no logs found
          } else {
            // If the data is successfully loaded, show it in a ListView
            List<LogData> logs = snapshot.data!;
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return ListTile(
                  title: Text(log.logTitle),
                  subtitle: Text(
                      '${DateFormat('dd-MM-yyyy hh:mm a').format(log.dateTime)} - ${log.logMessage}'),
                  trailing: showLogLevel(logLevel: log.logLevel),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget showLogLevel({required String logLevel}) {
    if (logLevel == "WARNING") {
      return Text(
        logLevel,
        style: TextStyle(color: Colors.amber),
      );
    } else if (logLevel == "ERROR") {
      return Text(
        logLevel,
        style: TextStyle(color: Colors.red),
      );
    } else {
      return Text(
        logLevel,
        style: TextStyle(color: Colors.black),
      );
    }
  }
}
