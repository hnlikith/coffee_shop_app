import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_app/core/constants/app_colors.dart';
import 'package:coffee_shop_app/core/constants/app_strings.dart';
import 'package:coffee_shop_app/controllers/cart_controller.dart';
import 'package:coffee_shop_app/screens/checkout/checkout_screen.dart';
import 'package:coffee_shop_app/widgets/size_selector.dart';

/// Coffee detail screen — light theme matching reference design
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.lightTextPrimary,
              size: 20.sp,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Detail',
          style: GoogleFonts.sora(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
        ),
        actions: [
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.favorite_border,
                color: AppColors.lightTextPrimary,
                size: 22.sp,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final coffee = cartController.selectedCoffee.value;
        if (coffee == null) {
          return const Center(child: Text('No coffee selected'));
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Coffee Image ───
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Hero(
                    tag: 'coffee-${coffee.id}',
                    child: coffee.imageUrl.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: coffee.imageUrl,
                          width: double.infinity,
                          height: 226.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 226.h,
                            color: AppColors.lightCard,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 226.h,
                            color: AppColors.lightCard,
                            child: Icon(
                              Icons.coffee,
                              color: AppColors.primary,
                              size: 60.sp,
                            ),
                          ),
                        )
                      : Image.asset(
                          coffee.imageUrl,
                          width: double.infinity,
                          height: 226.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 226.h,
                            color: AppColors.lightCard,
                            child: Icon(
                              Icons.coffee,
                              color: AppColors.primary,
                              size: 60.sp,
                            ),
                          ),
                        ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    // ─── Name ───
                    Text(
                      coffee.name,
                      style: GoogleFonts.sora(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      coffee.category,
                      style: GoogleFonts.sora(
                        fontSize: 12.sp,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // ─── Rating + Info Row ───
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.star, size: 20.sp),
                        SizedBox(width: 4.w),
                        Text(
                          coffee.rating.toStringAsFixed(1),
                          style: GoogleFonts.sora(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightTextPrimary,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(230)',
                          style: GoogleFonts.sora(
                            fontSize: 12.sp,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                        const Spacer(),
                        _buildInfoIcon(Icons.local_fire_department),
                        SizedBox(width: 12.w),
                        _buildInfoIcon(Icons.water_drop),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Divider
                    Container(
                      height: 1,
                      color: AppColors.lightBorder,
                    ),

                    SizedBox(height: 20.h),

                    // ─── Description ───
                    Text(
                      AppStrings.description,
                      style: GoogleFonts.sora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.sora(
                          fontSize: 13.sp,
                          color: AppColors.lightTextSecondary,
                          height: 1.7,
                        ),
                        children: [
                          TextSpan(text: coffee.description),
                          TextSpan(
                            text: ' Read More',
                            style: GoogleFonts.sora(
                              fontSize: 13.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ─── Size ───
                    Text(
                      AppStrings.size,
                      style: GoogleFonts.sora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(() => SizeSelector(
                          selectedSize: cartController.selectedSize.value,
                          onSizeChanged: cartController.selectSize,
                        )),

                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
        );
      }),

      // ─── Bottom Bar: Price + Buy Now ───
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Price
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: GoogleFonts.sora(
                    fontSize: 12.sp,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Obx(() => Text(
                      '\$ ${cartController.unitPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.sora(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    )),
              ],
            ),

            SizedBox(width: 24.w),

            // Buy Now
            Expanded(
              child: SizedBox(
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => const CheckoutScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.buyNow,
                    style: GoogleFonts.sora(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoIcon(IconData icon) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, color: AppColors.primary, size: 22.sp),
    );
  }
}
