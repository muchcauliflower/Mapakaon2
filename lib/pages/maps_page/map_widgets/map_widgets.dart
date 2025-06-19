import 'package:flutter/material.dart';
import 'package:mapakaon2/utils/appColors.dart';

import '../../../utils/screenDimensions.dart';

PreferredSizeWidget buildMapAppBar({
  required BuildContext context,
  required bool isAddingMarkers,
  required VoidCallback onToggleAdd,
  required VoidCallback onClear,
  required bool debugMode,
  VoidCallback? onShowRoutes,
  void Function(String)? onSaveRoute,
}) {
  return AppBar(
    title: const Text(
      'Interactive Map Routes',
      style: TextStyle(color: appColor),
    ),
    backgroundColor: bgColor,
    actions: [
      IconButton(
        color: appColor,
        icon: Icon(isAddingMarkers ? Icons.edit_off : Icons.add_location_alt),
        onPressed: onToggleAdd,
        tooltip: isAddingMarkers ? 'Stop Adding' : 'Add Marker',
      ),
      IconButton(
        color: appColor,
        icon: const Icon(Icons.clear),
        onPressed: onClear,
        tooltip: 'Clear Points',
      ),
      if (debugMode && onSaveRoute != null)
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: 'Save Route',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                String routeName = '';
                return AlertDialog(
                  title: const Text('Save Route'),
                  content: TextField(
                    onChanged: (value) => routeName = value,
                    decoration: const InputDecoration(hintText: 'Route name'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (routeName.isNotEmpty) {
                          onSaveRoute(routeName);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      if (debugMode && onShowRoutes != null)
        IconButton(
          icon: const Icon(Icons.list),
          tooltip: 'Show Saved Routes',
          onPressed: onShowRoutes,
        ),
    ],
  );
}

// search bar
class MapSearchBar extends StatelessWidget {
  const MapSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.blockSizeVertical;
    final w = SizeConfig.blockSizeHorizontal;

    return Positioned(
      top: h * 8,
      left: w * 6,
      right: w * 6,
      child: Container(
        height: h * 7,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF223442),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFF5B5B5B)),
            const SizedBox(width: 12),
            Text(
              'Search',
              style: TextStyle(
                fontFamily: 'Fredoka One',
                fontSize: h * 2.3,
                color: const Color(0xFF5B5B5B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Carousel widget
class carouselDisplay extends StatefulWidget {
  const carouselDisplay({super.key});

  @override
  State<carouselDisplay> createState() => _carouselDisplayState();
}

class _carouselDisplayState extends State<carouselDisplay> {
  final PageController _pageController = PageController(viewportFraction: 0.7); // change how thicc or thin the carousel box is
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.blockSizeVertical;
    final w = SizeConfig.blockSizeHorizontal;

    return Positioned(
      bottom: h * 15,
      left: w * 0.06,
      right: w * 0.06,
      child: SizedBox(
        height: h * 15,
        child: PageView.builder(
          controller: _pageController,
          itemCount: 10,
          itemBuilder: (context, index) {
            final double distanceFromCurrent = (_currentPage - index).abs();
            final double scale = 1 - (distanceFromCurrent * 0.3).clamp(0.0, 0.3);
            final double opacity = 1 - (distanceFromCurrent * 0.5).clamp(0.0, 0.5);
            final double horizontalShift = (index - _currentPage) * -10;

            final bool isFocused = index == _currentPage.round();

            return Transform.translate(
              offset: Offset(horizontalShift, 0),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xA0C88022),
                        borderRadius: BorderRadius.circular(20),
                        border: isFocused
                            ? Border.all(color: Color(0xFF223442), width: 2)
                            : null,
                        boxShadow: [
                          if (distanceFromCurrent < 0.5)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Card $index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class MapBottomNavBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const MapBottomNavBar({
    super.key,
    required this.onTabSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final h = SizeConfig.blockSizeVertical;
    final w = SizeConfig.blockSizeHorizontal;

    return Positioned(
      bottom: h * 5,
      left: w * 9,
      right: w * 9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navButton(icon: Icons.home, index: 0),
          _navButton(icon: Icons.map, index: 1),
          _navButton(icon: Icons.history, index: 2),
          _navButton(icon: Icons.settings, index: 3),
        ],
      ),
    );
  }

  Widget _navButton({required IconData icon, required int index}) {
    final isActive = index == currentIndex;
    final h = SizeConfig.blockSizeVertical;
    final size = h * 8;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFd9d9d9) : const Color(0xFF223442),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFFFBA02A) : const Color(0xFF5B5B5B),
          size: size * 0.5,
        ),
      ),
    );
  }
}
