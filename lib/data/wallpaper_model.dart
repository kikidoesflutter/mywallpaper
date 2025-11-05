class Wallpaper {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final int downloads;
  final List<String> tags;
  final String description;
  bool isFavorite;
  bool isActive;

  Wallpaper({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.downloads,
    this.tags = const [],
    this.description = '',
    this.isFavorite = false,
    this.isActive = false,
  });
}

class Category {
  final String name;
  final String imageUrl;
  final int wallpaperCount;
  final String description;

  Category({
    required this.name,
    required this.imageUrl,
    required this.wallpaperCount,
    required this.description,
  });
}
