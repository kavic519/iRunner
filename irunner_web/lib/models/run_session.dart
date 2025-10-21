import 'package:latlong2/latlong.dart';

class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate({required this.latitude, required this.longitude});

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class RunSession {
  final String id;
  final DateTime date;
  final double distanceInMeters;
  final int durationInSeconds;
  final List<Coordinate> route;

  RunSession({
    required this.id,
    required this.date,
    required this.distanceInMeters,
    required this.durationInSeconds,
    required this.route,
  });

  Duration get duration => Duration(seconds: durationInSeconds);
  
  // Pace in seconds per kilometer
  double get paceInSecondsPerKm {
    if (distanceInMeters == 0) return 0;
    return durationInSeconds / (distanceInMeters / 1000);
  }
  
  LatLng get startLocation => LatLng(route.first.latitude, route.first.longitude);

  factory RunSession.fromJson(Map<String, dynamic> json) {
    var routeFromJson = json['route'] as List? ?? [];
    List<Coordinate> routeList = routeFromJson.map((i) => Coordinate.fromJson(i)).toList();

    // 修正 date 字段解析，容错处理
    DateTime date;
    if (json['date'] == null || json['date'].toString().isEmpty) {
      date = DateTime.now(); // 或者 DateTime(2000) 作为默认
    } else {
      try {
        date = DateTime.parse(json['date'].toString());
      } catch (_) {
        date = DateTime.now();
      }
    }

    return RunSession(
      id: json['id'].toString(),
      date: date,
      distanceInMeters: json['distanceInMeters'] is double
          ? json['distanceInMeters']
          : (json['distanceInMeters'] is int
          ? (json['distanceInMeters'] as int).toDouble()
          : double.tryParse(json['distanceInMeters'].toString()) ?? 0.0),
      durationInSeconds: json['durationInSeconds'] is int
          ? json['durationInSeconds']
          : int.tryParse(json['durationInSeconds'].toString()) ?? 0,
      route: routeList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'distanceInMeters': distanceInMeters,
      'durationInSeconds': durationInSeconds,
      'route': route.map((c) => c.toJson()).toList(),
    };
  }
}
