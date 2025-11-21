/// Represents a single 3D pose landmark from MediaPipe.
///
/// Each landmark contains:
/// - [x], [y]: Normalized 2D coordinates (0.0 to 1.0)
/// - [z]: Depth coordinate relative to hips (in same scale as x/y)
/// - [visibility]: Confidence score (0.0 to 1.0)
class PoseLandmark {
  final double x;
  final double y;
  final double z;
  final double visibility;

  PoseLandmark({
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
  });

  /// Creates a [PoseLandmark] from a Map received from the Platform Channel.
  factory PoseLandmark.fromMap(Map<dynamic, dynamic> map) {
    return PoseLandmark(
      x: (map['x'] as num).toDouble(),
      y: (map['y'] as num).toDouble(),
      z: (map['z'] as num).toDouble(),
      visibility: (map['visibility'] as num).toDouble(),
    );
  }

  /// Converts the landmark to a Map for debugging or serialization.
  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'z': z,
      'visibility': visibility,
    };
  }

  @override
  String toString() {
    return 'PoseLandmark(x: ${x.toStringAsFixed(3)}, y: ${y.toStringAsFixed(3)}, '
        'z: ${z.toStringAsFixed(3)}, visibility: ${visibility.toStringAsFixed(2)})';
  }
}
