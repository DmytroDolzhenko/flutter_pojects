import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import '../models/gallery_item.dart';
import '../services/permission_service.dart';
import '../services/storage_service.dart';
import 'photo_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final PermissionService _permissionService = PermissionService();
  final StorageService _storageService = StorageService();

  List<GalleryItem> _galleryItems = [];
  bool _isLoading = true;
  bool _isMultiSelectMode = false;

  @override
  void initState() {
    super.initState();
    _loadSavedGallery();
  }

  Future<void> _loadSavedGallery() async {
    final paths = await _storageService.loadPaths();
    setState(() {
      _galleryItems = paths.map((path) => GalleryItem(path: path)).toList();
      _isLoading = false;
    });
  }

  Future<void> _updateStoredPaths() async {
    final paths = _galleryItems.map((item) => item.path).toList();
    await _storageService.savePaths(paths);
  }

  Future<String?> _cropImage(String sourcePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Редагувати фото',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Редагувати фото',
            doneButtonTitle: 'Готово',
            cancelButtonTitle: 'Скасувати',
          ),
        ],
      );
      return croppedFile?.path;
    } catch (e) {
      debugPrint("Кроп скасовано або сталась помилка: $e");
      return null;
    }
  }

  Future<String> _saveImageToLocalStorage(String inputPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${directory.path}/my_gallery');
    
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final fileExtension = p.extension(inputPath);
    final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
    final savedFilePath = '${photosDir.path}/$fileName';

    await File(inputPath).copy(savedFilePath);
    return savedFilePath;
  }

  Future<void> _processImageSelection(ImageSource source) async {
    PermissionStatus permissionStatus;
    if (source == ImageSource.camera) {
      permissionStatus = await _permissionService.requestCameraPermission();
    } else {
      permissionStatus = await _permissionService.requestGalleryPermission();
    }

    if (!permissionStatus.isGranted) {
      _handlePermissionDenied(permissionStatus, source == ImageSource.camera ? "Камера" : "Галерея");
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile == null) return; 

      setState(() => _isLoading = true);

      final String? croppedPath = await _cropImage(pickedFile.path);
      final String pathToSave = croppedPath ?? pickedFile.path;

      final String finalPath = await _saveImageToLocalStorage(pathToSave);

      setState(() {
        _galleryItems.insert(0, GalleryItem(path: finalPath));
      });
      await _updateStoredPaths();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка обробки фото: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePermissionDenied(PermissionStatus status, String featureName) {
    if (status.isPermanentlyDenied) {
      _showSettingsDialog(featureName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Доступ до конфіденційної функції "$featureName" відхилено.')),
      );
    }
  }

  void _showSettingsDialog(String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Необхідний доступ: $featureName'),
        content: Text('Ви назавжди заблокували цей дозвіл. Будь ласка, перейдіть у налаштування ОС додатка, щоб увімкнути його.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Налаштування'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSinglePhoto(int index) async {
    try {
      final file = File(_galleryItems[index].path);
      if (await file.exists()) {
        await file.delete();
      }
      setState(() {
        _galleryItems.removeAt(index);
      });
      await _updateStoredPaths();
    } catch (e) {
      debugPrint("Помилка видалення: $e");
    }
  }

  Future<void> _deleteSelectedPhotos() async {
    final selectedItems = _galleryItems.where((item) => item.isSelected).toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Масове видалення'),
        content: Text('Ви впевнені, що хочете видалити ${selectedItems.length} фотографій?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Скасувати')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);

              for (var item in selectedItems) {
                try {
                  final file = File(item.path);
                  if (await file.exists()) {
                    await file.delete();
                  }
                } catch (e) {
                  debugPrint("Помилка видалення файлу: $e");
                }
              }

              setState(() {
                _galleryItems.removeWhere((item) => item.isSelected);
                _isMultiSelectMode = false;
              });
              await _updateStoredPaths();
              setState(() => _isLoading = false);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Видалити всі'),
          )
        ],
      ),
    );
  }

  void _showSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Зробити знімок з Камери'),
              onTap: () {
                Navigator.pop(context);
                _processImageSelection(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_size_select_actual_outlined),
              title: const Text('Обрати з Галереї'),
              onTap: () {
                Navigator.pop(context);
                _processImageSelection(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: const Text('Скасувати', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int selectedCount = _galleryItems.where((item) => item.isSelected).length;

    return Scaffold(
      appBar: AppBar(
        title: _isMultiSelectMode 
            ? Text('Виділено: $selectedCount') 
            : const Text('My Photos 📷'),
        actions: [
          if (_isMultiSelectMode) ...[
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: selectedCount > 0 ? _deleteSelectedPhotos : null,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isMultiSelectMode = false;
                  for (var item in _galleryItems) {
                    item.isSelected = false;
                  }
                });
              },
            )
          ] else ...[
            IconButton(
              icon: const Icon(Icons.add_a_photo),
              onPressed: _showSourceBottomSheet,
            ),
          ]
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _galleryItems.isEmpty
              ? _buildEmptyState()
              : _buildGridView(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text('Галерея порожня', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Натисніть на іконку камери вгорі, щоб додати медіа', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(6),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: _galleryItems.length,
      itemBuilder: (context, index) {
        final item = _galleryItems[index];

        return GestureDetector(
          onLongPress: () {
            if (!_isMultiSelectMode) {
              setState(() {
                _isMultiSelectMode = true;
                item.isSelected = true;
              });
            }
          },
          onTap: () {
            if (_isMultiSelectMode) {
              setState(() {
                item.isSelected = !item.isSelected;
                if (_galleryItems.every((e) => !e.isSelected)) {
                  _isMultiSelectMode = false; // Вимикаємо мод, якщо нічого не вибрано
                }
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetailScreen(
                    imagePath: item.path,
                    index: index,
                    onDelete: () => _deleteSinglePhoto(index),
                  ),
                ),
              );
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Hero(
                  tag: 'photo_$index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(item.path),
                      fit: BoxFit.cover,
                      // Оптимізація пам'яті завантаження прев'ю
                      cacheWidth: 300, 
                      cacheHeight: 300,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isMultiSelectMode)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(
                    item.isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: item.isSelected ? Colors.blue : Colors.white70,
                    size: 24,
                  ),
                ),
              if (_isMultiSelectMode && item.isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}