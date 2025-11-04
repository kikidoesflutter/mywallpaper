import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/wallpaper_model.dart';
import '../providers/wallpaper_provider.dart';

class WallpaperDetailScreen extends StatefulWidget {
  final Wallpaper wallpaper;

  const WallpaperDetailScreen({super.key, required this.wallpaper});

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  int _selectedIndex = 1;
  late Wallpaper selectedWallpaper;
  bool _isGridView = true;
  final List<Map<String, dynamic>> _tabs = [
    {'label': 'Home', 'icon': Icons.home_outlined},
    {'label': 'Browse', 'icon': Icons.grid_view_outlined},
    {'label': 'Favorite', 'icon': Icons.favorite_border},
    {'label': 'Settings', 'icon': Icons.settings_outlined},
  ];

  @override
  void initState() {
    super.initState();
    selectedWallpaper = widget.wallpaper;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                        onTap: () => setState(() {}),
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
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tab['label'],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(width: 24),
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: isDesktop
            ? _buildDesktopLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Consumer<WallpaperProvider>(
      builder: (context, provider, child) {
        final categoryWallpapers = provider.getWallpapersByCategory(
          selectedWallpaper.category,
        );
        final isFavorite = provider.wallpapers
            .firstWhere((w) => w.id == selectedWallpaper.id)
            .isFavorite;
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop(context);
                          },
                        ),
                        Text(
                          'Back to Categories',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedWallpaper.category,
                          style: TextStyle(
                            fontFamily: 'ClashDisplay-Medium',
                            fontSize: 48,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.grid_view,
                                color: _isGridView
                                    ? const Color(0xFFFF8C42)
                                    : Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _isGridView = true;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.view_list,
                                color: !_isGridView
                                    ? const Color(0xFFFF8C42)
                                    : Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _isGridView = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _isGridView
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.7,
                                  ),
                              itemCount: categoryWallpapers.length,
                              itemBuilder: (context, index) {
                                return _buildWallpaperItem(
                                  categoryWallpapers[index],
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: categoryWallpapers.length,
                              itemBuilder: (context, index) {
                                return _buildWallpaperListItem(
                                  categoryWallpapers[index],
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 1, child: _buildDetailsContent(context)),
                        const SizedBox(width: 40),
                        Expanded(flex: 1, child: _buildPhonePreview()),
                      ],
                    ),
                    const SizedBox(height: 55),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              provider.toggleFavorite(selectedWallpaper.id);
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.black87,
                              size: 18,
                            ),
                            label: Text(
                              'Save to Favorites',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(200, 60),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              _showWallpaperSetupDialog(
                                context,
                                provider,
                                selectedWallpaper,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF8C42),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              minimumSize: const Size(200, 60),
                            ),
                            child: Text(
                              'Set to Wallpaper',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(selectedWallpaper.imageUrl, fit: BoxFit.cover),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: _buildDetailsContent(context),
          ),
        ),
      ],
    );
  }

  Widget _buildWallpaperItem(Wallpaper wallpaper) {
    final isSelected = wallpaper.id == selectedWallpaper.id;
    final isActive = wallpaper.isActive;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedWallpaper = wallpaper;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: const Color(0xFFFF8C42), width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(wallpaper.imageUrl, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              _buildWallpaperOverlay(wallpaper, isActive),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWallpaperListItem(Wallpaper wallpaper) {
    final isSelected = wallpaper.id == selectedWallpaper.id;
    final isActive = wallpaper.isActive;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedWallpaper = wallpaper;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: const Color(0xFFFF8C42), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                wallpaper.imageUrl,
                width: 120,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    wallpaper.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C42).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      wallpaper.category,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFFF8C42),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildWallpaperListActions(wallpaper, isActive),
          ],
        ),
      ),
    );
  }

  Widget _buildWallpaperListActions(Wallpaper wallpaper, bool isActive) {
    return Consumer<WallpaperProvider>(
      builder: (context, provider, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C42),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Active',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            IconButton(
              icon: Icon(
                wallpaper.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: wallpaper.isFavorite ? Colors.red : Colors.grey[700],
              ),
              onPressed: () {
                provider.toggleFavorite(wallpaper.id);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildWallpaperOverlay(Wallpaper wallpaper, bool isActive) {
    return Positioned(
      top: 8,
      right: 8,
      child: Row(
        children: [
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C42),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 12, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    'Active',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 4),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withOpacity(0.9),
            child: Consumer<WallpaperProvider>(
              builder: (context, provider, _) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    wallpaper.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 16,
                    color: wallpaper.isFavorite ? Colors.red : Colors.grey[700],
                  ),
                  onPressed: () {
                    provider.toggleFavorite(wallpaper.id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhonePreview() {
    return Container(
      width: 260,
      height: 480,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: Colors.black, width: 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                selectedWallpaper.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 100,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 140,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsContent(BuildContext context) {
    return Consumer<WallpaperProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PREVIEW',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            _buildDetailLabel('Name'),
            const SizedBox(height: 20),
            Text(
              selectedWallpaper.title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 50),
            _buildDetailLabel('Tags'),
            const SizedBox(height: 20),
            Wrap(
              spacing: 2,
              runSpacing: 2,
              children: (selectedWallpaper.tags).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            _buildDetailLabel('Description'),
            const SizedBox(height: 8),
            Text(
              selectedWallpaper.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.shuffle),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildDetailLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.grey[600],
      ),
    );
  }
}

void _showWallpaperSetupDialog(
  BuildContext context,
  WallpaperProvider provider,
  Wallpaper selectedWallpaper,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Wallpaper Setup',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: WallpaperSetupDrawer(
          wallpaper: selectedWallpaper,
          onApply: () {
            provider.setActiveWallpaper(selectedWallpaper.id);
            Navigator.pop(context);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Wallpaper activated successfully!',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}

class WallpaperSetupDrawer extends StatefulWidget {
  final Wallpaper wallpaper;
  final VoidCallback onApply;

  const WallpaperSetupDrawer({
    super.key,
    required this.wallpaper,
    required this.onApply,
  });

  @override
  State<WallpaperSetupDrawer> createState() => _WallpaperSetupDrawerState();
}

class _WallpaperSetupDrawerState extends State<WallpaperSetupDrawer> {
  String _displayMode = 'Fit';
  bool _autoRotation = false;
  bool _lockWallpaper = false;
  bool _syncAcrossDevices = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        width: 450,
        height: double.infinity,
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallpaper Setup',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Configure your wallpaper settings and enable auto-rotation',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Activate Wallpaper',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Set the selected wallpaper as your desktop background',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Activated',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Display mode',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...[
                ('Fit', 'Scale to fit without cropping'),
                ('Fill', 'Scale to fill the entire screen'),
                ('Stretch', 'Stretch to fill the screen'),
                ('Tile', 'Repeat the image to fill the screen'),
              ].map((option) {
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade300, width: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  child: RadioListTile<String>(
                    title: Text(
                      option.$1,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      option.$2,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    value: option.$1,
                    groupValue: _displayMode,
                    activeColor: const Color(0xFFFF8C42),
                    onChanged: (value) => setState(() => _displayMode = value!),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300, width: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,

                child: SwitchListTile(
                  title: Text(
                    'Auto - Rotation',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Automatically change your wallpaper at regular intervals',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  value: _autoRotation,
                  activeColor: const Color(0xFFFF8C42),
                  onChanged: (value) => setState(() => _autoRotation = value),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Advanced Settings',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300, width: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: CheckboxListTile(
                  title: Text(
                    'Lock Wallpaper',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Prevent accidental changes',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  value: _lockWallpaper,
                  activeColor: const Color(0xFFFF8C42),
                  onChanged: (value) => setState(() => _lockWallpaper = value!),
                ),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300, width: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: CheckboxListTile(
                  title: Text(
                    'Sync Across Devices',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Keep wallpaper consistent on all devices',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  value: _syncAcrossDevices,
                  activeColor: const Color(0xFFFF8C42),
                  onChanged: (value) =>
                      setState(() => _syncAcrossDevices = value!),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x00000000),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        minimumSize: const Size(200, 60),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onApply,
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
                        'Save Settings',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
