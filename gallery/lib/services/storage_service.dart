import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _storageKey = 'gallery_image_paths';

  Future<void> savePaths(List<String> paths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, paths);
  }

  Future<List<String>> loadPaths() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_storageKey) ?? [];
  }
}