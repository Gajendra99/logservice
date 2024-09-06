<b>LogService</b> is a simple Dart-based logging utility that allows you to log messages, errors, and warnings to a text file. It also enables users to share the log file for troubleshooting purposes. This library is designed for Flutter apps and works well on Android (will be on iOS soon).

## Usage

To use this package, add <b>logservice</b> as a dependency in your pubspec.yaml file.

## Features

<ul>
<li><b>Save Log Error to File</b>
</li>
<li><b>Share Log file easily</b>
</li>
<li><b>View Saved Logs</b>
</li>
<li><b>View Filtered Logs based on Date & Log Level</b>
</li>
</ul>
<hr>

## Getting started

Follow this steps to use this package

## Install

```html
logservice: ^1.0.0
```

## How To Use
<b>Import Package</b>
```dart
import 'logservice/logservice.dart';
```

<b>Initialize LogService Class</b>
```dart 
LogService logService = LogService();
```
<b>now call logService.initLogFile() to create file and access it.</b>

```dart
logService.initLogFile();
```

<b>When any error occurs call this</b>

```dart
LogStatus status = await widget.logService.setLog(
          errorTitle: "Error Title",
          errorMessage: "Error Message",
          level: LogLevel.WARNING);
```
<B>Get Filtered Logs</B>
```dart
LogData data = await logService.getFilteredLogs(
      logLevel: LogLevel.WARNING,
      startDate: DateTime(2023, 8, 1),
      endDate: DateTime.now(),
    );

```
<b>Share Log File</b>
```dart
await logService.shareLog();
```




<hr>
## Future Updates
<ul>
<li><b>Save log file to customized location</b>
</li>
<li><b>Set max file size</b>
</li>
<li><b>Delete log after specific days limit</b>
</li>
<li><b>View Filtered Logs based on Date & Log Level</b>
</li>
<li><b>Save customized log (with extra details)</b>
</li>
</ul>
<hr>


## Developer

<H3>Gajendra Somawat</H3>
<p>Instagram: <a href="https://www.instagram.com/gajendra_menaria9">gajendra_menaria9</a></p>

## Additional Details

for more details visit example page or contact on <a href="https://www.instagram.com/gajendra_menaria9">Instagram</a>