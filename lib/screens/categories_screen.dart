import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../widgets/category_card.dart';
import 'wallpaper_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 3 : screenWidth > 600 ? 2 : 1;


    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFFBB03B), Color(0xFFEC0C43)],
                ).createShader(bounds),
                child: Text(
                  'Browse Categories',
                  style: TextStyle(
                    fontFamily: 'ClashDisplay-Medium',
                    fontSize: 60,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.grid_view,
                      color: _isGridView ? const Color(0xFFFF8C42) : Colors.grey,
                    ),
                    onPressed: () => setState(() => _isGridView = true),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.view_list,
                      color: !_isGridView ? const Color(0xFFFF8C42) : Colors.grey,
                    ),
                    onPressed: () => setState(() => _isGridView = false),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Explore curated collections of stunning wallpapers',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Consumer<WallpaperProvider>(
              builder: (context, provider, child) {
                final categories = provider.allCategories;
                if (_isGridView) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final categoryWallpapers = provider.getWallpapersByCategory(categories[index].name);
                      return CategoryCard(
                        category: categories[index],
                        onTap: () {
                          if (categoryWallpapers.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WallpaperDetailScreen(
                                  wallpaper: categoryWallpapers.first,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                } else{
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            final provider = Provider.of<WallpaperProvider>(context, listen: false);
                            final wallpapers = provider.wallpapers
                                .where((w) => w.category == category.name)
                                .toList();
                            if (wallpapers.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WallpaperDetailScreen(wallpaper: wallpapers.first),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                  child: Image.asset(
                                    category.imageUrl,
                                    width: 200,
                                    height: double.infinity,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          category.name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          category.description,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            '${categories.length} wallpapers',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}