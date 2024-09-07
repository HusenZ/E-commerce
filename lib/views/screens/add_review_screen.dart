import 'package:cached_network_image/cached_network_image.dart';
import 'package:gozip/bloc/review_bloc/add_review_bloc.dart';
import 'package:gozip/bloc/review_bloc/add_review_events.dart';
import 'package:gozip/bloc/review_bloc/add_review_states.dart';
import 'package:gozip/config/theme/colors_manager.dart';
import 'package:gozip/views/screens/home_screen.dart';
import 'package:gozip/views/widgets/common_widgets/delevated_button.dart';
import 'package:gozip/views/widgets/common_widgets/loading_button.dart';
import 'package:gozip/views/widgets/common_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.productId});
  final String imageUrl;
  final String productId;
  final String name;
  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  double _rating = 0;
  String _review = "";
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductReviewBloc, ProductReviewState>(
      listener: (context, state) {
        if (state is ProductReviewLoading) {
          setState(() {
            _isLoading = true;
          });
          return;
        }
        Navigator.of(context, rootNavigator: true).pop();
        if (state is ProductReviewFailure) {
          setState(() {
            _isLoading = false;
          });
        }
        if (state is ProductReviewSuccess) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Review'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.sp),
                        child: SizedBox(
                          height: 12.h,
                          width: 12.h,
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 56.w,
                            child: Text(
                              widget.name,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontSize: 14.sp,
                                      color: ColorsManager.blackColor),
                            ),
                          ),
                          Text(
                            "Rate The Prouduct",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating: _rating,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 24,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _rating = rating;
                                  });
                                },
                              ),
                              Text('  ($_rating / 5.0)'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  height: 20.h,
                  width: 90.w,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your review';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 50,
                      decoration: InputDecoration(
                        labelText: 'Write your review',
                        labelStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          _review = text;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.sp),
                _isLoading
                    ? const LoadingButton()
                    : DelevatedButton(
                        text: "Submit",
                        onTap: () {
                          if (_rating == 0.0 &&
                              _formKey.currentState!.validate()) {
                            customSnackBar(
                                context, 'Update The Review/Rating ', false);
                          } else {
                            BlocProvider.of<ProductReviewBloc>(context)
                                .add(AddReviewEvent(
                              productId: widget.productId,
                              rating: _rating,
                              review: _review,
                            ));
                          }
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
