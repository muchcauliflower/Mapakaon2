import 'package:flutter/material.dart';

class DirectionsWidget extends StatelessWidget {
  final VoidCallback onBack;
  final List<String> stepInstructions;

  const DirectionsWidget({
    super.key,
    required this.onBack,
    required this.stepInstructions,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        // Optional: debug print size changes
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.25,
        minChildSize: 0.2,
        maxChildSize: 0.75,
        snap: true,
        snapSizes: const [0.25, 0.5, 0.75],
        builder: (context, scrollController) {
          return Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            elevation: 12,
            color: Colors.white,
            child: Column(
              children: [
                // 👉 Grab handle that *can* initiate drag
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragStart: (_) {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),

                // 🔙 Header with back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: onBack,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Step-by-Step Directions',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // 📜 Scrollable list of steps
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: stepInstructions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(stepInstructions[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
