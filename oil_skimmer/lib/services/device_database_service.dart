import 'package:firebase_database/firebase_database.dart';
import 'package:oil_skimmer/models/device_data.dart';
import 'package:stacked/stacked.dart';

const dbCode = 'sZwMl5X1kvhzFVnq6CV7UDJpWDo2';

class DeviceDatabaseService with ListenableServiceMixin {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // DeviceMovement? _node;
  // DeviceMovement? get node => _node;

  // void setUpNodeListening() {
  //   DatabaseReference startCountRef = _db.ref('/devices/$dbCode/signal');

  //   try {
  //     startCountRef.onValue.listen((DatabaseEvent event) {
  //       if (event.snapshot.exists) {
  //         _node = DeviceMovement.fromMap(event.snapshot.value as Map);
  //         notifyListeners();
  //       }
  //     });
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  void setDeviceData(DeviceMovement data) {
    DatabaseReference dataRef = _db.ref('/devices/$dbCode/signal');

    dataRef.update(data.toJson());

    dataRef.update(data.toJson());
    print(data.direction);
  }
}
