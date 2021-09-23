import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class MediaService {
  /// allowedExtensions ['jpg', 'pdf', 'doc', 'xlsx'] <-- EG
  Future<Uint8List?> pickFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    try {
      var result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        return result.files.single.bytes;
      }
      // User canceled the picker
      return null;
    } catch (e) {
      return null;
    }
  }
}
