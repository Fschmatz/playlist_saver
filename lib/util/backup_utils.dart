import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:playlist_saver/redux/actions.dart';
import 'package:playlist_saver/service/app_parameter_service.dart';
import 'package:playlist_saver/util/toast_utils.dart';
import 'package:playlist_saver/util/utils_functions.dart';

import '../class/backup.dart';
import '../db/playlist_dao.dart';
import '../main.dart';

class BackupUtils {
  final playlistDao = PlaylistDao.instance;

  Future<void> backupData() async {
    Map<String, dynamic> backup = await _loadBackupData();

    if (backup['playlists'].isNotEmpty) {
      await _saveListAsJsonAndShare(backup);
      await AppParameterService().saveLastBackupDate();

      ToastUtils.show(
        "Backup complete!",
      );
    } else {
      ToastUtils.showErrorMessage(
        "No data found!",
      );
    }
  }

  Future<bool> _saveListAsJsonAndShare(Map<String, dynamic> data) async {
    try {
      final directory = await getTemporaryDirectory();
      final newFileName = UtilsFunctions.getBackupFilename();
      final file = File('${directory.path}/$newFileName');
      
      await file.writeAsString(json.encode(data));
      
      await Share.shareXFiles([XFile(file.path)], text: 'Backup $newFileName');
      return true;
    } catch (e) {
      ToastUtils.showErrorMessage('Error!');
      return false;
    }
  }

  Future<bool> restoreBackupData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        
        Backup backup = Backup.fromJson(json.decode(jsonString));
        
        await _deleteAllData();
        await store.dispatch(RestoreBackupAction(backup));
        
        ToastUtils.showSuccess();
        return true;
      }
      return false;
    } catch (e) {
      ToastUtils.showErrorMessage('Error!');
      return false;
    }
  }

  Future<Map<String, dynamic>> _loadBackupData() async {
    List<Map<String, dynamic>> playlistsJson = await playlistDao.queryAllRows();
    List<Map<String, dynamic>> parametersJson = await AppParameterService().loadAllParameters();

    Backup backupEntity = Backup(playlists: playlistsJson, parameters: parametersJson);

    Map<String, dynamic> backupJson = backupEntity.toJson();

    return backupJson;
  }

  Future<void> _deleteAllData() async {
    await playlistDao.deleteAll();
    await AppParameterService().deleteAllParameters();
  }
}
