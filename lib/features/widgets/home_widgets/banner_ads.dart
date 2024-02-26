import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BannerAds extends StatelessWidget {
  const BannerAds({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        //1st Image of Slider
        displayAd(
            "https://th.bing.com/th/id/OIP.HCKLr50nafiaajtSwkh6VAHaD4?w=1200&h=628&rs=1&pid=ImgDetMain"),

        //2nd Image of Slider
        displayAd(
            "https://i.pinimg.com/originals/7a/6e/a4/7a6ea4a21caa95076bfeb5cffbae0b72.jpg"),

        //3rd Image of Slider
        displayAd(
            "https://i.pinimg.com/originals/7a/6e/a4/7a6ea4a21caa95076bfeb5cffbae0b72.jpg"),

        //4th Image of Slider
        displayAd(
            "https://www.jdmedia.co.za/images/carousel/Ecommerce-Banner-1920.jpg"),

        //5th Image of Slider
        displayAd(
            "https://www.jdmedia.co.za/images/carousel/Ecommerce-Banner-1920.jpg"),
      ],

      //Slider Container properties
      options: CarouselOptions(
        height: 12.h,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
    );
  }

  Material displayAd(String url) {
    return Material(
      elevation: 4.0,
      child: Container(
        margin: const EdgeInsets.all(6.0),
        height: 5.h,
        width: 86.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Image.network(
          url,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
