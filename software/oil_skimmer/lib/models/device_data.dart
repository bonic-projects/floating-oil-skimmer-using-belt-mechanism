class DeviceMovement {
  String? direction;
  bool? isBelt;
  bool? isPumpOn;
  bool? isDumpOn;

  DeviceMovement({
    this.direction,
    this.isBelt,
    this.isPumpOn,
    this.isDumpOn,
  });

  factory DeviceMovement.fromMap(Map data) {
    return DeviceMovement(
      direction: data['direction'],
      isBelt: data['isBelt'],
      isPumpOn: data['isPumpOn'],
      isDumpOn: data['isDumpOn'],
    );
  }

  Map<String, dynamic> toJson() => {
        'isBelt': isBelt,
        'isPumpOn': isPumpOn,
        'isDumpOn': isDumpOn,
        'direction': direction,
      };
}

/// Device Sensor Reading model
class DeviceReading {
  int oil;
  DateTime lastSeen;

  DeviceReading({
    required this.oil,
    required this.lastSeen,
  });

  factory DeviceReading.fromMap(Map data) {
    return DeviceReading(
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
      oil: data['oil'] ?? 0,
    );
  }
}
