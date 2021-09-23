import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobility_one/services/excel_service.dart';
import 'package:mobility_one/services/media_service.dart';
import 'package:mobility_one/ui/widgets/cancel_button.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/m_one_dialog_wrapper.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/util/my_text_styles.dart';

enum ImportScreen {
  Vehicles,
  Persons,
}

class BulkImportDialog extends StatefulWidget {
  final String title;
  final bool isLoading;
  final ImportScreen importScreen;
  final List<ColHeader> colHeadersList;
  final Function(List<Map<String, String>> records) onUpload;

  BulkImportDialog({
    Key? key,
    required this.title,
    required this.isLoading,
    required this.onUpload,
    required this.importScreen,
    required this.colHeadersList,
  }) : super(key: key);

  @override
  _BulkImportDialogState createState() => _BulkImportDialogState();
}

class _BulkImportDialogState extends State<BulkImportDialog> {
  final MediaService mediaService = MediaService();

  final ExcelService excelService = ExcelService();

  bool hasDownloadedTemplate = false;

  Excel? excelFile;

  ExcelImportResponse? excelImportResponse;

  /// check if uploaded excel file is valid
  bool _canContinue() {
    if (excelFile == null) return false;
    if (excelImportResponse == null) return false;
    if (excelImportResponse!.fatalError) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return MOneDialogWrapper(
        children: [
          Center(
            child: Container(height: 300, child: MyCircularProgressIndicator()),
          )
        ],
      );
    }

    return MOneDialogWrapper(
      children: [
        Text(
          '${widget.title}',
          style: MyTextStyles.h1Style,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Steps',
                style: MyTextStyles.h2Style,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '1) Download the template below.',
                  style: MyTextStyles.pStyle,
                ),
              ),
              SizedBox(
                width: 200,
                child: ConfirmButton(
                  expanded: true,
                  onPressed: () {
                    if (widget.importScreen == ImportScreen.Vehicles) {
                      excelService.downloadImportVehicleTemplate();
                    } else if (widget.importScreen == ImportScreen.Persons) {
                      excelService.downloadImportPersonsTemplate();
                    }

                    hasDownloadedTemplate = true;

                    setState(() {});
                  },
                  title: 'Download template',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  '2) Upload the updated excel file.',
                  style: MyTextStyles.pStyle,
                ),
              ),
              ConfirmButton(
                canClick: hasDownloadedTemplate,
                onPressed: () async {
                  final excelFileUnit8List = await mediaService.pickFile(
                    type: FileType.custom,
                    allowedExtensions: ['xlsx'],
                  );

                  if (excelFileUnit8List != null) {
                    excelFile = excelService.readExcelFile(excelFileUnit8List);

                    if (excelFile == null) return;

                    excelImportResponse = excelService.getRecordsListFromExcel(
                      excelFile!,
                      expectedHeaders: widget.colHeadersList,
                    );

                    setState(() {});
                  }
                },
                title: 'Upload file',
              ),
            ],
          ),
        ),

        // if errors, tell us
        if (excelImportResponse != null &&
            excelImportResponse!.errors.isNotEmpty)
          Container(
            child: Column(
              children: [
                Divider(),
                ...excelImportResponse!.errors.map((error) {
                  return Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5,
                    ),
                    color: Colors.red.withOpacity(.1),
                    child: Text(
                      '$error',
                      style: TextStyle(color: Colors.white60),
                    ),
                  );
                }),
                Divider(),
              ],
            ),
          ),

        // buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CancelButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 10),
            ConfirmButton(
              canClick: _canContinue(),
              onPressed: () async {
                await widget.onUpload(excelImportResponse!.recordsToImport);
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }
}
