import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffee_shop_app/core/constants/app_colors.dart';
import 'package:coffee_shop_app/controllers/coffee_controller.dart';
import 'package:coffee_shop_app/controllers/cart_controller.dart';
import 'package:coffee_shop_app/controllers/location_controller.dart';
import 'package:coffee_shop_app/screens/detail/detail_screen.dart';
import 'package:coffee_shop_app/widgets/coffee_card.dart';
import 'package:coffee_shop_app/widgets/category_chip.dart';
import 'package:coffee_shop_app/widgets/promo_banner.dart';

/// Home screen matching reference design:
/// Dark top section (location, search, promo, categories)
/// Light bottom section (product grid)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coffeeController = Get.find<CoffeeController>();
    final cartController = Get.find<CartController>();
    final locationController = Get.find<LocationController>();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Obx(() {
        if (coffeeController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ════════════════════════════════════════
              // DARK TOP SECTION
              // ════════════════════════════════════════
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.darkBackground,
                      AppColors.darkBackground,
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // ─── Location Header ───
                      Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: GoogleFonts.sora(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Obx(() => Text(
                                          locationController.currentLocation.value,
                                          style: GoogleFonts.sora(
                                            fontSize: 14.sp,
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.textPrimary,
                                      size: 18.sp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Avatar
                            Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // ─── Search Bar ───
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.darkSurface,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: TextField(
                            onChanged: coffeeController.searchProducts,
                            style: GoogleFonts.sora(
                              color: AppColors.textPrimary,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search coffee',
                              hintStyle: GoogleFonts.sora(
                                color: AppColors.textMuted,
                                fontSize: 14.sp,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: AppColors.textPrimary,
                                size: 20.sp,
                              ),
                              suffixIcon: Container(
                                margin: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.tune_rounded,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // ─── Promo Banner ───
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: const PromoBanner(),
                      ),

                      SizedBox(height: 20.h),

                      // ─── Category Chips ───
                      SizedBox(
                        height: 40.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          physics: const BouncingScrollPhysics(),
                          itemCount: coffeeController.categories.length,
                          itemBuilder: (context, index) {
                            final category =
                                coffeeController.categories[index];
                            return Obx(() => CategoryChip(
                                  label: category.name,
                                  isSelected:
                                      coffeeController.selectedCategory.value ==
                                          category.name,
                                  onTap: () => coffeeController
                                      .filterByCategory(category.name),
                                ));
                          },
                        ),
                      ),

                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),

              // ════════════════════════════════════════
              // LIGHT BOTTOM SECTION — Product Grid
              // ════════════════════════════════════════
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
                child: Obx(() {
                  final products = coffeeController.filteredProducts;

                  if (products.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 60.h),
                      child: Column(
                        children: [
                          Icon(
                            Icons.coffee_outlined,
                            size: 60.sp,
                            color: AppColors.lightTextMuted,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No coffee found',
                            style: GoogleFonts.sora(
                              fontSize: 16.sp,
                              color: AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final coffee = products[index];
                      return CoffeeCard(
                        coffee: coffee,
                        onTap: () {
                          cartController.selectCoffee(coffee);
                          Get.to(
                            () => const DetailScreen(),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      }),

      // ─── Bottom Navigation Bar ───
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_filled, true),
                _buildNavItem(Icons.favorite_border, false),
                _buildNavItem(Icons.shopping_bag_outlined, false),
                _buildNavItem(Icons.notifications_outlined, false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? AppColors.primary : AppColors.lightTextMuted,
          size: 24.sp,
        ),
        if (isActive) ...[
          SizedBox(height: 4.h),
          Container(
            width: 10.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        ],
      ],
    );
  }
}
