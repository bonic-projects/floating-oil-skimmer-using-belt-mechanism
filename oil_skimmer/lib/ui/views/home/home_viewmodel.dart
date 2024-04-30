import 'package:oil_skimmer/app/app.locator.dart';
import 'package:oil_skimmer/app/app.logger.dart';
import 'package:oil_skimmer/models/device_data.dart';
import 'package:oil_skimmer/services/belt_database_service.dart';
import 'package:oil_skimmer/services/device_database_service.dart';
import 'package:oil_skimmer/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends ReactiveViewModel {
  final log = getLogger('HomeViewModel');
  final _deviceDatabaseService = locator<DeviceDatabaseService>();
  final _beltDatabaseService = locator<BeltDatabaseService>();
  final _bottomSheetService = locator<BottomSheetService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_beltDatabaseService];

  void onModelReady() {
    try {
      _deviceDatabaseService.setDeviceData(DeviceMovement(direction: 's'));
      _beltDatabaseService.setDeviceData(
          BeltMovement(isBelt: false, isPumpOn: false, isDumpOn: false));
      _beltDatabaseService.setUpNodeListening();

      notifyListeners();

      // if (node!.oil > 900) {
      //   stopAll();
      // }
    } catch (e) {
      log.i(e);
    }
  }

  DeviceReading? get node => _beltDatabaseService.node;

  void stopAll() {
    _beltDatabaseService.setDeviceData(
        BeltMovement(isBelt: false, isPumpOn: false, isDumpOn: false));
    _bottomSheetService.showCustomSheet(
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
    log.v("stopAll called");
  }

//init method it calls initially when the device is ready
  // HomeViewModel() {
  //   setBusy(true);
  //   _beltDatabaseService.setUpNodeListening();

  // //  log.i(node);

  //   setBusy(false);
  // }

  // void showBottomSheet() {
  //   _bottomSheetService.showCustomSheet(
  //     variant: BottomSheetType.notice,
  //     title: ksHomeBottomSheetTitle,
  //     description: ksHomeBottomSheetDescription,
  //   );
  // }

  void isBoatMovement(String value) {
    _deviceDatabaseService.setDeviceData(DeviceMovement(
      direction: value,
    ));
  }

//***********Belt Button Part************//
  bool _isBeltOn = false;
  bool get isBeltOn => _isBeltOn;

  void isBeltMovement(bool value) {
    _beltDatabaseService.setDeviceData(
        BeltMovement(isBelt: value, isPumpOn: false, isDumpOn: false));
  }

  String _beltButtonText = "";
  String get beltButtonText => _beltButtonText = _isBeltOn ? "Stop" : "Start";

  void toggleBeltButtonText() {
    _isBeltOn = !_isBeltOn;
    if (node!.oil < 900) {
      isBeltMovement(_isBeltOn);
      if (_isBeltOn) {
        _isPumpOn = false;
        _isDumpOn = false;
        // showBottomSheet();
        notifyListeners();
      }
    } else {
      stopAll();
      _beltButtonText = "Stop";
      notifyListeners();
    }
  }

  //**********************************//

//***********Pump Button*************//
  bool _isPumpOn = false;
  bool get isPumpOn => _isPumpOn;

  void isPumpMovement(bool value) {
    _beltDatabaseService.setDeviceData(
        BeltMovement(isBelt: false, isPumpOn: value, isDumpOn: false));
  }

  String _pumpButtonText = "";
  String get pumpButtonText => _pumpButtonText = _isPumpOn ? "Stop" : "Start";

  void togglePumpButtonText() {
    _isPumpOn = !_isPumpOn;
    if (node!.oil < 900) {
      isPumpMovement(_isPumpOn);
      if (_isPumpOn) {
        _isBeltOn = false;
        _isDumpOn = false;
        // showBottomSheet();
      }
      notifyListeners();
    } else {
      stopAll();

      _pumpButtonText = "Stop";
      notifyListeners();
    }
  }
  //*************************************//

//*****************Dump button*********************//
  bool _isDumpOn = false;
  bool get isDumpOn => _isDumpOn;

  void isDumpMovement(bool value) {
    _beltDatabaseService.setDeviceData(
        BeltMovement(isBelt: false, isPumpOn: false, isDumpOn: value));
  }

  String _dumpButtonText = "";
  String get dumpButtonText => _isDumpOn ? "Stop" : "Start";

  void toggleDumpButtonText() {
    _isDumpOn = !_isDumpOn;
    if (node!.oil < 900) {
      isDumpMovement(_isDumpOn);
      if (_isDumpOn) {
        _isBeltOn = false;
        _isPumpOn = false;
        // showBottomSheet();
      }
      notifyListeners();
    } else {
      stopAll();
      _dumpButtonText = "Stop";
      notifyListeners();
    }
  }
}
