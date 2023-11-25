import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  Future<File> saveAsCSV(List<Map<String, dynamic>> data) async {
    List<List<dynamic>> rows = [];

    rows.add(['Timestamp', 'Vehicle Number', 'Vehicle Warning', 'Time Period']);

    for (Map<String, dynamic> row in data) {
      rows.add([
        row['timestamp'],
        row['vehicleNum'],
        row['warning'],
        row['timePeriod']
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    String downloadDirPath = '/storage/emulated/0/Download';
    File file = File("$downloadDirPath/Logs.csv");
    print("Path: $downloadDirPath");
    return file.writeAsString(csv);
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Logs').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audit"),
        elevation: 20,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Timestamp')),
                  DataColumn(label: Text('Vehicle Number')),
                  DataColumn(label: Text('Vehicle Warning')),
                  DataColumn(label: Text('Time Period')),
                ],
                rows: snapshot.data!.map((row) {
                  return DataRow(cells: [
                    DataCell(Text(row['timestamp'].toString())),
                    DataCell(Text(row['vehicleNum'].toString())),
                    DataCell(Text(row['warning'].toString())),
                    DataCell(Text(row['timePeriod'].toString())),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
        onPressed: () async {
          try {
            PermissionStatus status = await Permission.storage.status;
            print('Permission status: $status');
            if (!status.isGranted) {
              await Permission.storage.request();
            }
            List<Map<String, dynamic>> data = await fetchData();
            print('Fetched data: $data');
            await saveAsCSV(data);
            print('Data saved as CSV');
          } catch (e) {
            print('Error: $e');
          }
        },
        label: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.download_for_offline),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Download"),
            )
          ],
        ),
      ),
    );
  }
}
