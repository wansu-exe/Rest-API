class Breed {
  final String name;
  final List<String> subBreeds;

  Breed({required this.name, required this.subBreeds});

  // The API sends {"bulldog": ["boston", "english"]}, so each entry arrives as a key + value.
  factory Breed.fromJson(String name, dynamic subs) => Breed(
        name: name,
        subBreeds: List<String>.from(subs as List),
      );
}

class DogImage {
  final String url;

  DogImage({required this.url});

  factory DogImage.fromJson(Map<String, dynamic> json) =>
      DogImage(url: json['message'] as String);
}
