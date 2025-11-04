import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../widgets/wallpaper_card.dart';

class FavoritesScreen extends StatelessWidget {
  final VoidCallback? onNavigateToBrowse;

  const FavoritesScreen({super.key, this.onNavigateToBrowse});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 6 : screenWidth > 800 ? 4 : screenWidth > 600 ? 3 : 2;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFBB03B), Color(0xFFEC0C43)],
            ).createShader(bounds),
            child: Text(
              'Saved Wallpapers',
              style: TextStyle(
                fontFamily: 'ClashDisplay-Medium',
                fontSize: 60,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your saved wallpapers collection',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Consumer<WallpaperProvider>(
              builder: (context, provider, child) {
                final favorites = provider.favoriteWallpapers;
                if (favorites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(-17, 0),
                              child: Transform.rotate(
                                angle: 0.90,
                                child: Container(
                                  width: 90,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(-15, 0),
                              child: Transform.rotate(
                                angle: 0.90,
                                child: Icon(Icons.image, size: 20, color: Colors.white60),
                              ),
                            ),
                            SizedBox(width: 10),
                            Transform.translate(
                              offset: Offset(20, 0),
                              child: Transform.rotate(
                                angle: -0.95,
                                child: Container(
                                  width: 90,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(20, 0),
                              child: Transform.rotate(
                                angle: -0.6,
                                child: Container(
                                  width: 130,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No saved wallpapers',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start saving your favorite wallpapers to see them here',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: onNavigateToBrowse,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8C42),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                            minimumSize: const Size(200, 60),
                          ),
                          child: Text(
                            'Browse Wallpapers',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    return WallpaperCard(wallpaper: favorites[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}