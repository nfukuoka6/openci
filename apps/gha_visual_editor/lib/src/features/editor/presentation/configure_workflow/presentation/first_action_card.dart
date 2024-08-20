import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/constants/margins.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_workflow/presentation/configure_workflow.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/connector_dot.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/editor_page.dart';
import 'package:signals/signals_flutter.dart';

class FirstActionCard extends StatelessWidget {
  const FirstActionCard({
    super.key,
    required this.dotKey,
  });

  final GlobalKey dotKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 145,
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.transparent,
                  width: 4,
                ),
              ),
              child: Container(
                width: 340,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.firstStepDarkGray,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.borderBlack,
                    width: 1.5, // Set border width to 1 pixel
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Watch((context) => Text(
                            workflowNameSignal.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    verticalMargin4,
                    Watch(
                      (context) => Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'on ',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: '${onSignal.value.name} ',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: '-> ${branchSignal.value}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    verticalMargin20,
                    const Divider(
                      color: AppColors.borderBlack,
                      thickness: 1.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 4),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Configure Workflow'),
                                  content: SizedBox(
                                    height: 350,
                                    child: ConfigureWorkflow(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConnectorDot(
              key: dotKey,
              dotColor: AppColors.bluePoint,
              borderColor: AppColors.borderBlack,
              dotPaddingColor: AppColors.firstStepDarkGray,
              drawTop: false,
            ),
          ),
        ],
      ),
    );
  }
}
