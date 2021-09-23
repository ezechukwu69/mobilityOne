import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:mobility_one/util/debugBro.dart';

// const String VEHICLES_SHEET = 'vehicles sheet';
const String redColorHex = '#FF0000';
const String blackColorHex = '#000000';
const String badRowText = 'One or more records have missing required fields';

class ExcelService {
  Excel? excel;
  List<ColHeader>? expectedHeaders;

  ///
  ExcelImportResponse getRecordsListFromExcel(
    Excel excel, {
    required List<ColHeader> expectedHeaders,
  }) {
    this.excel = excel;
    this.expectedHeaders = expectedHeaders;

    //
    final tableName = excel.tables.keys.first;
    final table = excel.tables[tableName];

    if (table == null) {
      // failed to locate table
      return ExcelImportResponse(
        fatalError: true,
        errors: ['Failed to located sheet!'],
      );
    }

    var headersIndex = findHeadersRowIndex(table);

    if (headersIndex == null) {
      /// failed to located row with headers
      return ExcelImportResponse(
        fatalError: true,
        errors: ['Failed to locate row with Headers!'],
      );
    }

    var records = List<Map<String, String>>.from([]);
    var nonFatalErrors = <String>[];

    // for each row in the sheet
    for (var rowIndex = 0; rowIndex < table.rows.length; rowIndex++) {
      var row = table.rows[rowIndex];

      if (rowIndex > headersIndex) {
        try {
          var colIndex = -1;
          var record = <String, String>{};

          var rowIsValid = true;

          // for each cloumn in the row
          for (var colHeader in expectedHeaders) {
            colIndex++;
            rowIsValid = true;

            var rowCell = row[colIndex];
            var valueInCell = rowCell?.value.toString().trim() ?? '';

            if (colHeader.isRequired && valueInCell.isEmpty) {
              // missing required field
              rowIsValid = false;

              if (nonFatalErrors.isEmpty) {
                nonFatalErrors.add(badRowText);
              }

              break;
            }

            record[colHeader.dbColName] = valueInCell;
          }

          // add row
          if (rowIsValid) records.add(record);
        } catch (e) {
          logger.e(e);

          /// we should never get here
          return ExcelImportResponse(
            fatalError: true,
            errors: ['Something went wrong, please contact support.'],
          );
        }
      }
    }

    // ilog(records);

    return ExcelImportResponse(
      recordsToImport: records,
      errors: nonFatalErrors,
    );
  }

  /// returns the index of the row that has the headers
  /// returns null if not found
  int? findHeadersRowIndex(Sheet table) {
    // for each row in the table
    for (var row in table.rows) {
      var headersMatch = true;

      // for each column in the row
      for (var colIndex = 0; colIndex < expectedHeaders!.length; colIndex++) {
        try {
          headersMatch = true;
          final cell = row[colIndex];
          final cellValue = cell?.value.toString().trim() ?? '';
          final expectedHeadersTitle = expectedHeaders![colIndex].title;

          if (cellValue != expectedHeadersTitle) {
            headersMatch = false;
            break;
          }
        } catch (e) {
          headersMatch = false;
          break;
        }
      }

      if (headersMatch) {
        return row.first!.rowIndex;
      }
    }

    return null;
  }

  void downloadImportVehicleTemplate() {
    creatImportTemplate(vehiclesListHeaderFormat, fileName: 'vehicles_import');
  }

  void downloadImportPersonsTemplate() {
    creatImportTemplate(personsHeaderFormat, fileName: 'persons_import');
  }

  void creatImportTemplate(
    List<ColHeader> colHeaderList, {
    required String fileName,
  }) {
    try {
      var excel = Excel.createExcel();

      var sheetName = excel.getDefaultSheet() ?? 'Sheet1';

      excel.updateCell(
        sheetName,
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        'Read me',
        cellStyle: CellStyle(bold: true),
      );

      excel.updateCell(
        sheetName,
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
        '- Please do not modify the column headers',
      );

      excel.updateCell(
        sheetName,
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2),
        '- Values for column headers marked in red are required',
      );

      for (var i = 0; i < colHeaderList.length; i++) {
        //
        var colHeader = colHeaderList[i];

        var colHeaderStyle = CellStyle(
          fontColorHex: colHeader.isRequired ? redColorHex : blackColorHex,
          bold: true,
        );

        excel.updateCell(
          sheetName,
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 4),
          colHeader.title,
          cellStyle: colHeaderStyle,
        );
      }

      excel.save(fileName: '$fileName.xlsx');
    } catch (e) {
      elog(e);
    }
  }

  ///
  Excel? readExcelFile(Uint8List bytes) {
    try {
      var excel = Excel.decodeBytes(bytes);
      return excel;
    } catch (e) {
      return null;
    }
  }
}

class ExcelImportResponse {
  /// cannot continue
  bool fatalError;

  List<Map<String, String>> recordsToImport;

  List<String> errors;

  ExcelImportResponse({
    this.recordsToImport = const [],
    this.fatalError = false,
    this.errors = const [],
  });
}

/// Column Header
class ColHeader {
  final String title;
  final bool isRequired;

  // name in database
  final String dbColName;

  ColHeader({
    required this.title,
    this.isRequired = false,
    required this.dbColName,
  });
}

List<ColHeader> vehiclesListHeaderFormat = [
  ColHeader(
    title: 'Display Name',
    dbColName: 'DisplayName',
    isRequired: true,
  ),
  ColHeader(
    title: 'Licence Plate',
    dbColName: 'LicencePlate',
    isRequired: true,
  ),
  ColHeader(
    title: 'VIN',
    dbColName: 'VIN',
    isRequired: true,
  ),
  ColHeader(
    title: 'Type',
    dbColName: 'Type',
  ),
  ColHeader(
    title: 'Model',
    dbColName: 'Model',
  ),
  ColHeader(
    title: 'Pool',
    dbColName: 'PoolId',
    isRequired: true,
  ),
  ColHeader(
    title: 'Vehicle Type',
    dbColName: 'VehicleTypeId',
    isRequired: true,
  ),
  ColHeader(
    title: 'General Status',
    dbColName: 'GeneralStatusId',
    isRequired: true,
  ),
  ColHeader(
    title: 'Availability',
    dbColName: 'AvailabilityId',
    isRequired: true,
  ),
];

List<ColHeader> personsHeaderFormat = [
  ColHeader(
    title: 'First Name',
    dbColName: 'FirstName',
    isRequired: true,
  ),
  ColHeader(
    title: 'Second Name',
    dbColName: 'LastName',
    isRequired: true,
  ),
  ColHeader(
    title: 'Email',
    dbColName: 'Email',
    isRequired: true,
  ),
  ColHeader(
    title: 'Org. Unit',
    dbColName: 'OrgUnitId',
    isRequired: true,
  ),
];
