import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class DogApi {
  static const _base = 'https://dog.ceo/api';
  static const _timeout = Duration(seconds: 8);

  // One place for the status-code check, the timeout, and JSON decoding.
  static Future<Map<String, dynamic>> _get(String path) async {
    final res = await http.get(Uri.parse('$_base$path')).timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Server returned ${res.statusCode}');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['status'] != 'success') throw Exception('API reported a failure');
    return json;
  }

  // Screen 1: one-time fetch.
  static Future<List<Breed>> fetchBreeds() async {
    final json = await _get('/breeds/list/all');
    final message = json['message'] as Map<String, dynamic>;
    return message.entries.map((e) => Breed.fromJson(e.key, e.value)).toList();
  }

  static Future<DogImage> _fetchRandomImage() async =>
      DogImage.fromJson(await _get('/breeds/image/random'));

  // Screen 2: a new random dog every 5 seconds.
  // A failed fetch is pushed as an error event; the timer keeps running.
  static Stream<DogImage> randomImageStream() {
    late final StreamController<DogImage> controller;
    Timer? timer;

    Future<void> tick() async {
      try {
        controller.add(await _fetchRandomImage());
      } catch (e) {
        controller.addError(e);
      }
    }

    controller = StreamController<DogImage>(
      onListen: () {
        tick();
        timer = Timer.periodic(const Duration(seconds: 5), (_) => tick());
      },
      onCancel: () => timer?.cancel(),
    );
    return controller.stream;
  }
}
