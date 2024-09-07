import 'package:gozip/config/theme/colors_manager.dart';
import 'package:gozip/views/widgets/common_widgets/loading_dailog.dart';
import 'package:gozip/views/widgets/common_widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CancelOrderBottomSheet extends StatefulWidget {
  final Function(String) onCancelSelected; // Callback for selected reason

  const CancelOrderBottomSheet({super.key, required this.onCancelSelected});

  // Define the list of cancellation reasons
  static const List<String> cancellationReasons = [
    "I changed my mind about this purchase.",
    "I found the same product elsewhere for a better price.",
    "The product description was inaccurate.",
    "I no longer need the product.",
    "I am not available to receive the delivery at this time.",
    "I accidentally placed the order.",
    "I entered the wrong address.",
    "Other (please specify):",
  ];

  @override
  State<CancelOrderBottomSheet> createState() => _CancelOrderBottomSheetState();
}

class _CancelOrderBottomSheetState extends State<CancelOrderBottomSheet> {
  // Variable to store the selected reason index
  int _selectedReasonIndex = -1;
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  children: [
                    Text(
                      "Are you sure you want to cancel your order?",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: ColorsManager.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.sp),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          CancelOrderBottomSheet.cancellationReasons.length,
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          title: Text(
                            CancelOrderBottomSheet.cancellationReasons[index],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          value: index,
                          groupValue: _selectedReasonIndex,
                          onChanged: (value) {
                            setState(() {
                              _selectedReasonIndex = value as int;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    if (_selectedReasonIndex ==
                        CancelOrderBottomSheet.cancellationReasons.length - 1)
                      DTextformField(
                        controller: _editingController,
                        readOnly: false,
                        hintText: "Specifiy the reason here",
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: _selectedReasonIndex >= 0
                              ? () {
                                  LoadingDialog.showLoaderDialog(context);
                                  if (_selectedReasonIndex == 7) {
                                    widget.onCancelSelected(
                                        _editingController.text);
                                    Navigator.pop(context);
                                  } else {
                                    widget.onCancelSelected(
                                        CancelOrderBottomSheet
                                                .cancellationReasons[
                                            _selectedReasonIndex]);
                                    Navigator.pop(context);
                                  }
                                }
                              : null,
                          child: const Text("Confirm Cancellation"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
