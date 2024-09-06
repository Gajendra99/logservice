library logservice;

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'Models/log_data.dart';
import 'Models/log_status.dart';

enum LogLevel { INFO, WARNING, ERROR }

class LogService {
  File? logFile;

  // Initialize the log file
  Future<void> initLogFile() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/app_logs.txt';
    logFile = File(path);

    // Create the file if it doesn't exist
    if (!(await logFile!.exists())) {
      await logFile!.create();
    }
  }

  Future<bool> deleteFile() async {
    try {
      if (logFile != null) {
        logFile!.delete();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Function to log an error with title and message
  Future<LogStatus> setLog(
      {required String errorTitle,
      required String errorMessage,
      required LogLevel level}) async {
    try {
      String logEntry =
          '${DateTime.now()};${level.toString().split('.').last.toUpperCase()};$errorTitle;$errorMessage\n';

      await logFile?.writeAsString(logEntry, mode: FileMode.append);
      return LogStatus(status: true, msg: "Log Saved Successfully");
    } catch (e) {
      return LogStatus(status: false, msg: e.toString());
    }
  }

  // Function to parse log file and filter logs based on criteria
  Future<List<LogData>> getFilteredLogs({
    required LogLevel? logLevel, // null means no filtering by log level
    required DateTime? startDate, // null means no filtering by date range
    required DateTime? endDate,
  }) async {
    List<LogData> filteredLogs = [];

    if (await logFile!.exists()) {
      List<String> logEntries = await logFile!.readAsLines();

      for (String logEntry in logEntries) {
        // Assuming the log format is: DateTime; LogLevel; LogTitle; LogMessage
        List<String> parts = logEntry.split(';');

        if (parts.length < 4) continue; // Skip if log format is incorrect

        DateTime logDate = DateTime.parse(parts[0].split(';').first);
        String level = parts[1].trim();
        String title = parts[2].trim();
        String message = parts[3].trim();

        // Filter by log level
        if (logLevel != null && level != logLevel.toString().split('.').last) {
          continue;
        }

        // Filter by date range
        if (startDate != null && logDate.isBefore(startDate)) {
          continue;
        }

        if (endDate != null && logDate.isAfter(endDate)) {
          continue;
        }

        // Add the filtered log to the list
        filteredLogs.add(LogData(
          dateTime: logDate,
          logLevel: level,
          logTitle: title,
          logMessage: message,
        ));
      }
    }

    return filteredLogs;
  }

  // shareLogFile
  Future<LogStatus> shareLog() async {
    try {
      if (logFile != null && await logFile!.exists()) {
        XFile xfile = XFile(logFile!.path);
        await Share.shareXFiles([xfile], subject: "Log Service Errors");

        return LogStatus(status: true, msg: "File Shared Successfully");
      } else {
        return LogStatus(status: false, msg: "File Not Found!");
      }
    } catch (e) {
      return LogStatus(status: false, msg: "$e");
    }
  }
}
