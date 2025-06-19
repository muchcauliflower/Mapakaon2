import 'package:flutter/material.dart';

class DirectionsWidget extends StatelessWidget {
  final VoidCallback onBack;

  const DirectionsWidget({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      top: MediaQuery.of(context).size.height * 0.25, // overlay top 75%
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top row with back button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step-by-Step Directions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onBack,
                ),
              ],
            ),
            const Divider(),

            // Placeholder list of directions
            Expanded(
              child: ListView.separated(
                itemCount: 5, // for now just dummy steps
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.black,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    title: Text('Proceed to step ${index + 1}'),
                    subtitle: const Text('Jeepney route or walking segment'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
