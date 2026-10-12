import 'package:flutter/material.dart';
import 'dog_api.dart';
import 'models.dart';

class BeltScreen extends StatefulWidget {
  const BeltScreen({super.key});

  @override
  State<BeltScreen> createState() => _BeltScreenState();
}

class _BeltScreenState extends State<BeltScreen> {
  final Stream<DogImage> _dogs = DogApi.randomImageStream(); // created once

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DogImage>(
      stream: _dogs,
      builder: (context, snap) {
        if (snap.hasError) {
          return const Center(
            child: Text('Connection problem. Retrying in a few seconds...'),
          );
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Image.network(
              snap.data!.url,
              errorBuilder: (_, __, ___) => const Text('Image failed to load'),
            ),
          ),
        );
      },
    );
  }
}
