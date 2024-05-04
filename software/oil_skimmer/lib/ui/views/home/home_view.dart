import 'package:flutter/material.dart';
import 'package:oil_skimmer/ui/common/ui_helpers.dart';
import 'package:oil_skimmer/ui/smart_widgets/online_status.dart';
import 'package:oil_skimmer/ui/views/home/Widgets/belt_button.dart';
import 'package:oil_skimmer/ui/views/home/Widgets/progress_indicator.dart';
import 'package:oil_skimmer/ui/views/home/Widgets/triangleWidget/dwnwd_triangle.dart';
import 'package:oil_skimmer/ui/views/home/Widgets/triangleWidget/frwrd_triangle.dart';
import 'package:oil_skimmer/ui/views/home/Widgets/triangleWidget/lftwrd_triangle.dart';
import 'package:oil_skimmer/ui/views/home/Widgets/triangleWidget/rgtward_triangle.dart';
import 'package:oil_skimmer/ui/views/home/Widgets/triangleWidget/stop_button.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: const Text('Home'),
            actions: const [
              IsOnlineWidget(),
            ],
          ),
          body: SafeArea(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      verticalSpaceMedium,
                      model.node?.oil == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.blueGrey[600],
                                  ),
                                  verticalSpaceSmall,
                                  Text(
                                    "Fetching...",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.blueGrey[700],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              child: ProgressBarcircular(
                                value: model.calculateValues(),
                              ),
                            ),
                      verticalSpaceMedium, // Added space
                      Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 9,
                              left: 76,
                              child: ForwardTriangle(
                                onTap: () => model.isBoatMovement('f'),
                              ),
                            ),
                            Positioned(
                              top: 70,
                              right: 13,
                              left: 16,
                              child: Row(
                                children: [
                                  LeftwardTriangle(
                                    onTap: () => model.isBoatMovement('l'),
                                  ),
                                  horizontalSpaceSmall,
                                  StopButton(
                                    onTap: () => model.isBoatMovement('s'),
                                  ),
                                  horizontalSpaceSmall,
                                  RightwardTriangle(
                                    onTap: () => model.isBoatMovement('r'),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 76,
                              child: DownwardTriangle(
                                onTap: () => model.isBoatMovement('b'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(
                        thickness: 2,
                        indent: 25,
                        endIndent: 25,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          horizontalSpaceMedium,
                          BeltButton(
                            buttonName: "Belt",
                            ontap: model.toggleBeltButtonText,
                            text: model.beltButtonText,
                            icon: Icons.conveyor_belt,
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          horizontalSpaceMedium,
                          BeltButton(
                            buttonName: 'Pump',
                            ontap: model.togglePumpButtonText,
                            text: model.pumpButtonText,
                            icon: Icons.heat_pump_outlined,
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          horizontalSpaceMedium,
                          BeltButton(
                            buttonName: 'Dump',
                            ontap: model.toggleDumpButtonText,
                            text: model.dumpButtonText,
                            icon: Icons.delete_forever_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.onModelReady();
      },
    );
  }
}
