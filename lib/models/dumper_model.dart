class Dumper {
  final String id;
  String name;
  String location;
  final String operator;
  String status;
  String? _imagePath; // Private field to hold the image path.

  Dumper({
    required this.id,
    required this.name,
    required this.location,
    required this.operator,
    required this.status,
    String? imagePath,
  }) : _imagePath = imagePath;

  // Getter for imagePath
  String? get imagePath => _imagePath;

  // Setter for imagePath
  set imagePath(String? path) {
    _imagePath = path;
  }
}
