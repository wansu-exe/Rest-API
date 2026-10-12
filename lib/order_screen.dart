import 'package:flutter/material.dart';
import 'dog_api.dart';
import 'models.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<Breed>> _breeds;

  @override
  void initState() {
    super.initState();
    _breeds = DogApi.fetchBreeds(); // called once, NOT inside build()
  }

  void _retry() => setState(() => _breeds = DogApi.fetchBreeds());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Breed>>(
      future: _breeds,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not load breeds. Check your connection.'),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _retry, child: const Text('Retry')),
              ],
            ),
          );
        }
        final breeds = snap.data!;
        if (breeds.isEmpty) {
          return const Center(child: Text('No breeds found.'));
        }
        return ListView.builder(
          itemCount: breeds.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(breeds[i].name),
            subtitle: Text(breeds[i].subBreeds.isEmpty
                ? 'No sub-breeds'
                : breeds[i].subBreeds.join(', ')),
          ),
        );
      },
    );
  }
}
