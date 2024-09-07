import 'package:gozip/config/theme/colors_manager.dart';
import 'package:gozip/views/widgets/common_widgets/delevated_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WelcomeDailogue {
  static void showWelcomeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: ColorsManager.whiteColor,
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              DelevatedButton(
                  text: 'Got It', onTap: () => Navigator.of(context).pop())
            ],
            title: Text(
              "Important",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            content: RichText(
              text: TextSpan(
                text:
                    '''Discover amazing products from local belagavi shops, Browse shops and buy from them. Please note that Gozip is not responsible for payment processing, returns or replacements. After placing an order the seller will contact you shortly to finalize your order and discuss payment and delivery options.''',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 14.sp),
              ),
            ));
      },
    );
  }
}
