import 'package:flutter/material.dart';
import '../data/wallpaper_model.dart';
import '../data/sample_data.dart';

class WallpaperProvider extends ChangeNotifier {
  List<Wallpaper> _wallpapers = [];
  List<Category> _categories = [];

  WallpaperProvider() {
    _wallpapers = List.from(sampleWallpapers);
    _categories = List.from(categories);

    print('Total wallpapers loaded: ${_wallpapers.length}');
    print('Total categories loaded: ${_categories.length}');

    final categoriesMap = <String, int>{};
    for (var wallpaper in _wallpapers) {
      categoriesMap[wallpaper.category] = (categoriesMap[wallpaper.category] ?? 0) + 1;
    }
    print('Wallpapers by category: $categoriesMap');
  }

  List<Wallpaper> get wallpapers => _wallpapers;
  List<Wallpaper> get favoriteWallpapers => _wallpapers.where((w) => w.isFavorite).toList();
  List<Category> get allCategories => _categories;
  Wallpaper? get activeWallpaper {
    try {
      return _wallpapers.firstWhere((w) => w.isActive);
    } catch (e) {
      return null;
    }
  }

  void toggleFavorite(String wallpaperId) {
    final index = _wallpapers.indexWhere((w) => w.id == wallpaperId);
    if (index != -1) {
      _wallpapers[index].isFavorite = !_wallpapers[index].isFavorite;
      notifyListeners();
    }
  }

  void setActiveWallpaper(String wallpaperId) {
    for (var wallpaper in _wallpapers) {
      wallpaper.isActive = wallpaper.id == wallpaperId;
    }
    notifyListeners();
  }

  List<Wallpaper> getWallpapersByCategory(String category) {
    return _wallpapers.where((w) => w.category == category).toList();
  }
}