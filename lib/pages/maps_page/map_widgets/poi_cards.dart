import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/Resto Dummy Data/poiClass.dart';

class PoiCard extends StatelessWidget {
  final PoiData data;
  final VoidCallback? onGetDirections;

  const PoiCard({
    super.key,
    required this.data,
    this.onGetDirections,
  });

  @override
  Widget build(BuildContext context) {
    final bool imageExists = data.poiImagePath.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBA02A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // LEFT COLUMN (Image/Icon)
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.hardEdge, // ensures child respects borderRadius
                    child: data.poiImagePath.isNotEmpty
                        ? Image.asset(
                      data.poiImagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.restaurant_menu,
                            size: 30,
                            color: Colors.black,
                          ),
                        );
                      },
                    )
                        : const Center(
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Uncomment if you want to show distance
                  // Text(
                  //   '${distanceKm.toStringAsFixed(1)} Km',
                  //   style: const TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 18,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          // RIGHT COLUMN (Details)
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.poiName,
                    style: const TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    data.poiAddress,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Wrap(
                    spacing: 6,
                    children: data.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.white70, size: 16),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          // What to do here
                          // 1. Fetch directions
                          // 2. Hide BottomNavigationBar and poi_cards
                          // 3. Show ListView of step-by-step directions
                          print('Get Directions tapped!');
                          if (onGetDirections != null) {
                            onGetDirections!();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.map_rounded, color: Colors.amber, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Get Directions',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
