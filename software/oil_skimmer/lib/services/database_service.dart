import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:oil_skimmer/app/app.logger.dart';
import 'package:oil_skimmer/models/device_data.dart';
import 'package:stacked/stacked.dart';

const String dbCode = 'sZwMl5X1kvhzFVnq6CV7UDJpWDo2';

class DatabaseService with ListenableServiceMixin {
  final log = getLogger('Database');
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DeviceReading? _node;
  DeviceReading? get node => _node;

  void setUpNodeListening() {
    DatabaseReference startCountRef = _db.ref('/devices/$dbCode/reading');
    log.i('setup node listening');

    try {
      log.i('try called');
      startCountRef.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          log.i('snapshot checked');
          log.i(event.snapshot.value);
          _node = DeviceReading.fromMap(event.snapshot.value as Map);
          log.i(_node?.oil);
          notifyListeners();
        }
      });
    } catch (e) {
      log.e(e);
    }
  }

  void setDeviceData(DeviceMovement data) {
    DatabaseReference dataRef = _db.ref('/devices/$dbCode/data');

    dataRef.update(data.toJson());

    print(data.direction);
  }

  void setBeltData(DeviceMovement data) {
    DatabaseReference dataRef = _db.ref('/devices/$dbCode/data');

    dataRef.update(data.toJson());

    if (kDebugMode) {
      print(data.direction);
    }
  }
}
