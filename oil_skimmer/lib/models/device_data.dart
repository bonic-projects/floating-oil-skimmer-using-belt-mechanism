class DeviceMovement {
  String? direction;

  DateTime? lastSeen;

  //

  DeviceMovement({
    required this.direction,
    this.lastSeen,
  });

//
  factory DeviceMovement.fromMap(Map data) {
    return DeviceMovement(
      direction: data['direction'],
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
    );
  }

  //
  Map<String, dynamic> toJson() => {
        'direction': direction,
        'ts': lastSeen,
      };
}

class BeltMovement {
  bool? isBelt;
  bool? isPumpOn;
  bool? isDumpOn;

  BeltMovement(
      {required this.isBelt, required this.isPumpOn, required this.isDumpOn});

  factory BeltMovement.fromMap(Map data) {
    return BeltMovement(
      isBelt: data['isBelt'],
      isPumpOn: data['isPumpOn'],
      isDumpOn: data['isDumpOn'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'isBelt': isBelt, 'isPumpOn': isPumpOn, 'isDumpOn': isDumpOn};
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
