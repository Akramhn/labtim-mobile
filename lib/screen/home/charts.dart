import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class ECG extends StatefulWidget {
  final String id;
  const ECG({super.key, required this.id});

  @override
  _ECGState createState() => _ECGState();
}

class _ECGState extends State<ECG> {
  Timer? _timer;
  final StreamController<List<DataPoint>> _dataStreamController =
      StreamController<List<DataPoint>>();

  @override
  void initState() {
    super.initState();
    fetchDataAndSetTimer();
  }

  void fetchDataAndSetTimer() async {
    await fetchData(); // Fetch initial data immediately
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      if (!_dataStreamController.isClosed) {
        await fetchData(); // Fetch data every 1 seconds if the stream is open
      } else {
        timer.cancel(); // Cancel the timer if the stream controller is closed
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dataStreamController.close();
    super.dispose();
  }

  Future<void> fetchData() async {
    const apiKey = 'BBFF-C22urwbWGmwKd9HONv3FzYmze669xi';
    const deviceLabel = 'labtim_mob';
    final variableLabel = 'ecg${widget.id}';

    final response = await http.get(
      Uri.parse(
          'https://industrial.api.ubidots.com/api/v1.6/devices/$deviceLabel/$variableLabel/values/?page_size=10'),
      headers: {
        'X-Auth-Token': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final responseData = response.body;
      parseDataAndUpdateChart(responseData);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void parseDataAndUpdateChart(String response) {
    final jsonData = json.decode(response);
    final List<dynamic> results = jsonData['results'];

    List<DataPoint> newData = [];
    for (var result in results) {
      final value = result['value'].toDouble();
      final timestamp = result['timestamp'];
      newData.add(DataPoint(value: value, timestamp: timestamp));
    }

    if (!_dataStreamController.isClosed) {
      _dataStreamController.add(newData); // Emit new data to the stream
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChartPage(dataStream: _dataStreamController.stream),
    );
  }
}

class DataPoint {
  final double value;
  final int timestamp;

  DataPoint({required this.value, required this.timestamp});

  factory DataPoint.fromJson(Map<String, dynamic> json) {
    return DataPoint(
      value: json['value'].toDouble(),
      timestamp: json['timestamp'],
    );
  }
}

class ChartPage extends StatefulWidget {
  final Stream<List<DataPoint>> dataStream;

  const ChartPage({super.key, required this.dataStream});

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<DataPoint> chartData = [];

  @override
  void initState() {
    super.initState();

    // Listen to the data stream and update the chart data
    widget.dataStream.listen((newData) {
      setState(() {
        chartData = newData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double minY = chartData.isNotEmpty
        ? chartData
            .map((point) => point.value)
            .reduce((min, value) => min < value ? min : value)
        : 0.0;

    double maxY = chartData.isNotEmpty
        ? chartData
            .map((point) => point.value)
            .reduce((max, value) => max > value ? max : value)
        : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ECG Chart'),
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: true),
              borderData: FlBorderData(
                  show: true, border: Border.all(color: Colors.blue)),
              minX: 0,
              maxX: chartData.length.toDouble() - 1,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: chartData
                      .asMap()
                      .map((index, point) => MapEntry(
                          index, FlSpot(index.toDouble(), point.value)))
                      .values
                      .toList(),
                  isCurved:
                      false, // Set this to false to make the line straight
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
