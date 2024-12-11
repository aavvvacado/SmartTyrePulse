class Tyre {
  final String name;
  final double pressure;

  final double temperature;

  Tyre({
    required this.name,
    required this.pressure,
    required this.temperature,
  });

  // Override == operator to compare tyres by name (or other unique identifiers)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tyre && other.name == name;
  }

  // Override hashCode to ensure consistency when comparing tyres
  @override
  int get hashCode => name.hashCode;

  // Pre-written default values for tyres (instead of fetching from Firebase)
  factory Tyre.defaultTyre() {
    return Tyre(
      name: 'Default Tyre',
      pressure: 32.5, // Default pressure value in PSI

      temperature: 75.0, // Default temperature in °C
    );
  }
}
