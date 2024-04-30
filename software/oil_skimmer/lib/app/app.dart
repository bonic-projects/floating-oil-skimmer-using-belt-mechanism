import 'package:oil_skimmer/services/belt_database_service.dart';
import 'package:oil_skimmer/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:oil_skimmer/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:oil_skimmer/ui/views/home/home_view.dart';
import 'package:oil_skimmer/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:oil_skimmer/services/device_database_service.dart';
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
    LazySingleton(classType: DeviceDatabaseService),
    LazySingleton(classType: BeltDatabaseService),
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
