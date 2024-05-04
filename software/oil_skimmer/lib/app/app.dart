import 'package:oil_skimmer/models/device_data.dart';
import 'package:oil_skimmer/services/database_service.dart';
import 'package:oil_skimmer/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:oil_skimmer/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:oil_skimmer/ui/views/home/home_view.dart';
import 'package:oil_skimmer/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DatabaseService),
    LazySingleton(classType: DeviceMovement),

// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
