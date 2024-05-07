import 'package:oil_skimmer/app/app.locator.dart';
import 'package:oil_skimmer/app/app.logger.dart';
import 'package:oil_skimmer/models/device_data.dart';
import 'package:oil_skimmer/services/database_service.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends ReactiveViewModel {
  final log = getLogger('HomeViewModel');
  final _databaseService = locator<DatabaseService>();

  final _bottomSheetService = locator<BottomSheetService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_databaseService];

  void onModelReady() {
    try {
      _databaseService.setDeviceData(DeviceMovement(
          direction: 's', isBelt: false, isPumpOn: false, isDumpOn: false));

      _databaseService.setUpNodeListening();

      notifyListeners();
    } catch (e) {
      log.i(e);
    }
  }

  DeviceReading? get node => _databaseService.node;

  void isBoatMovement(String value) {
    _databaseService.setDeviceData(DeviceMovement(
      direction: value,
    ));
  }

  //***********Belt Button Part************//
  bool _isBeltOn = false;
  bool get isBeltOn => _isBeltOn;

  String get beltButtonText => _isBeltOn ? "Stop" : "Start";

  void toggleBeltButtonText() {
    if (node!.oil < 900) {
      _isBeltOn = !_isBeltOn;
      setData();

      notifyListeners();
    }
  }

  //**********************************//

  //***********Pump Button*************//
  bool _isPumpOn = false;
  bool get isPumpOn => _isPumpOn;

  String get pumpButtonText => _isPumpOn ? "Stop" : "Start";

  void togglePumpButtonText() {
    if (node!.oil < 900) {
      _isPumpOn = !_isPumpOn;
      setData();

      notifyListeners();
    }
  }
  //*************************************//

  //*****************Dump button*********************//
  bool _isDumpOn = false;
  bool get isDumpOn => _isDumpOn;

  String get dumpButtonText => _isDumpOn ? "Stop" : "Start";

  void toggleDumpButtonText() {
    if (node!.oil < 900) {
      _isDumpOn = !_isDumpOn;
      setData();

      notifyListeners();
    }
  }

  void setData() {
    _databaseService.setDeviceData(DeviceMovement(
        isBelt: _isBeltOn, isPumpOn: _isPumpOn, isDumpOn: _isDumpOn));
  }

  double calculateValues() {
    double oil = node!.oil.toDouble();
    double full = 11;

    if (oil > full) oil = full;
    double percentage = ((full - oil) / full) * 100;
    return percentage.roundToDouble();
  }
}
