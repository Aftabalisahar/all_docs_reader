import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class ExcelReaderScreen extends StatefulWidget {
  final String filePath;

  final String fileName;

  const ExcelReaderScreen(
      {Key? key, required this.filePath, required this.fileName})
      : super(key: key);

  @override
  ExcelReaderScreenState createState() => ExcelReaderScreenState();
}

class ExcelReaderScreenState extends State<ExcelReaderScreen> {
  List<List<dynamic>> excelData = [];
  List<String> tables = [];
  Map<String, dynamic> tableRows = {};
  int index = 0;

  updateIndex(int updatedIndex) {
    setState(() {
      index = updatedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    readExcel();
  }

  Future<void> requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      readExcel();
    } else {
      // You can handle the case if the user denies the permission
      // You might want to show a dialog or message to inform the user.
    }
  }

  Future<void> readExcel() async {
    tables.clear();
    tableRows.clear();
    setState(() {});

    var file = File(widget.filePath);
    var bytes = await file.readAsBytes();
    // var bytes = await rootBundle.load('assets/simple.xlsx');
    var excel = Excel.decodeBytes(bytes.buffer.asUint8List());

    for (var table in excel.tables.keys) {
      // print("Table Data ============>>>>>>>$table");
      tables.add(table);
      List<List<Data?>> rowsList = [];
      for (var row in excel.tables[table]!.rows) {
        // rowsList.add(row);

        if (row.any((cell) => cell?.value != null)) {
          // print("Row Data ============>>>>>>> $row");
          rowsList.add(row);
          // If the row contains at least one non-null cell, process it
          for (var cell in row) {
            // print("Before Filter ${cell?.value}");

            if (cell?.value != null) {
              // print("After Filter ${cell?.value}");
            } else {
              // print("Before Filter ${cell?.value}");
            }

            // Add cell value to the list
          }
        } else {
          // If the row is empty, skip it
          // print("Empty Row, Skipping...");
        }
      }
      tableRows[table] = rowsList;
      setState(() {});
      // Assign rows list to the table name in the map
    }
  }

  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    pageController.animateToPage(index - 1,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.decelerate);
                  },
                  icon: Icon(Icons.arrow_back)),
              IconButton(
                  onPressed: () {
                    pageController.animateToPage(index + 1,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.decelerate);
                  },
                  icon: Icon(Icons.arrow_forward)),
            ],
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: PageView.builder(
              itemCount: tables.length,
              controller: pageController,
              onPageChanged: (value) {
                updateIndex(value);
              },
              reverse: false,
              itemBuilder: (context, pageIndex) {
                List<List<Data?>> tableRowsAt = tableRows[tables[pageIndex]];
                print(tableRowsAt[0].length);
                // Data data = tableRows[tables[0]][0][1];
                // print(data.value);
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          // physics: NeverScrollableScrollPhysics(),
                          child: DataTable(
                              columnSpacing: 10,
                              dataRowMinHeight: 20,
                              horizontalMargin: 0,
                              dataRowMaxHeight: 20,
                              border: TableBorder.all(color: Colors.grey),
                              columns: List.generate(
                                  tableRowsAt[0].length,
                                  (columnIndex) => DataColumn(
                                      label: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${getColumnLabel(columnIndex)}",
                                            textAlign: TextAlign.center,
                                          )))),
                              // tableRowsAt[0].length, (columnIndex) => DataColumn(label: Text("${tableRowsAt[0][columnIndex]?.value}"))),
                              rows: List.generate(
                                  tableRowsAt.length,
                                  (index) => DataRow(
                                      cells: List.generate(
                                          tableRowsAt[0].length,
                                          (rowIndex) => DataCell(Container(
                                                // color: Colors.grey,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "${tableRowsAt[index][rowIndex]?.value ?? ""}",
                                                  textAlign: TextAlign.center,
                                                ),
                                              )))))),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ))
        ],
      ),
    );
  }

  String getColumnLabel(int index) {
    String result = '';
    int alphabetSize = 26;

    while (index >= 0) {
      result = String.fromCharCode('A'.codeUnitAt(0) + (index % alphabetSize)) +
          result;
      index = (index / alphabetSize).floor() - 1;
    }

    return result;
  }
}
