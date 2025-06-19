import 'package:flutter/material.dart';
import 'package:mapakaon2/pages/maps_page/routing/routeStorage.dart';


class RoutePickerDialog extends StatelessWidget {
  const RoutePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Saved Routes'),
      content: SizedBox(
        width: double.maxFinite,
        child: storedRoutes.isEmpty
            ? const Text('No saved routes.')
            : ListView.builder(
          shrinkWrap: true,
          itemCount: storedRoutes.length,
          itemBuilder: (context, index) {
            final route = storedRoutes[index];
            return ListTile(
              title: Text(route.routeName),
              subtitle: Text('${route.coordinates.length} points'),
              onTap: () {
                Navigator.of(context).pop(route); // return route
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
