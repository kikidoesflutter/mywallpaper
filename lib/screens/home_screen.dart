import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../widgets/category_card.dart';
import 'categories_screen.dart';
import 'settings_screen.dart';
import 'favorites_screen.dart';
import 'wallpaper_detail_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {'label': 'Home', 'icon': Icons.home_outlined},
    {'label': 'Browse', 'icon': Icons.grid_view_outlined},
    {'label': 'Favorite', 'icon': Icons.favorite_border},
    {'label': 'Settings', 'icon': Icons.settings_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 48 : 24,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star_border_rounded,
                    size: 28,
                    color: const Color(0xFFFF8C42),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Wallpaper studio',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  ..._tabs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tab = entry.value;
                    final isSelected = _selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFF8C42)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                tab['icon'],
                                size: 18,
                                color: isSelected ? Colors.white : Colors.grey[700],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tab['label'],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: isSelected ? Colors.white : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _getSelectedScreen(),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const SavedWallpapersView();
      case 1:
        return const CategoriesScreen();
      case 2:
        return FavoritesScreen(
          onNavigateToBrowse: () => setState(() => _selectedIndex = 1),
        );
      case 3:
        return const SettingsScreen();
      default:
        return const SavedWallpapersView();
    }
  }
}

class SavedWallpapersView extends StatelessWidget {
  const SavedWallpapersView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 3 : screenWidth > 600 ? 2 : 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFBB03B), Color(0xFFEC0C43)],
            ).createShader(bounds),
            child: Text(
              'Discover Beautiful Wallpapers',
              style: const TextStyle(
                fontFamily: 'ClashDisplay-Medium',
                fontSize: 60,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),

          ),
          Text(
            'Discover curated collections of stunning wallpapers. Browse by\ncategory, preview in full-screen, and set your favorites.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          const SizedBox(height: 32),
          Consumer<WallpaperProvider>(
            builder: (context, provider, child) {
              final activeWallpaper = provider.activeWallpaper;

              if (activeWallpaper == null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFFBB03B), Color(0xFFEC0C43)],
                      ).createShader(bounds),
                      child: Text(
                        'Welcome to Wallpaper Studio',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Browse our collection of beautiful wallpapers and set your favorite as your device wallpaper.',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              }

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        activeWallpaper.imageUrl,
                        width: 70,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFFFF8C42), Color(0xFFFF6B6B)],
                            ).createShader(bounds),
                            child: Text(
                              'Your Active Wallpaper',
                              style: TextStyle(
                                fontFamily: 'ClashDisplay-Medium',
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'This wallpaper is currently set as your active background',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                'Category - ',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                activeWallpaper.category,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Selection - ',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                activeWallpaper.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          color: Colors.grey[600],
                          iconSize: 20,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.settings_outlined),
                          color: Colors.grey[600],
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),


          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () {
                  final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
                  homeScreenState?.setState(() {
                    homeScreenState._selectedIndex = 1;
                  });
                },
                child: Text(
                  'See All',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: const Color(0x80808080),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Consumer<WallpaperProvider>(
            builder: (context, provider, child) {
              final categories = provider.allCategories;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final categoryWallpapers = provider.getWallpapersByCategory(categories[index].name);
                  if (categoryWallpapers.isNotEmpty) {
                    return CategoryCard(
                      category: categories[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WallpaperDetailScreen(
                              wallpaper: categoryWallpapers.first,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return CategoryCard(
                    category: categories[index],
                    onTap: () {},
                  );

                },
              );
            },
          ),
        ],
      ),
    );
  }
}
