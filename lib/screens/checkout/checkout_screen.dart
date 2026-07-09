import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_app/core/constants/app_colors.dart';
import 'package:coffee_shop_app/core/constants/app_strings.dart';
import 'package:coffee_shop_app/controllers/cart_controller.dart';
import 'package:coffee_shop_app/controllers/location_controller.dart';
import 'package:coffee_shop_app/widgets/quantity_selector.dart';

/// Checkout screen — light theme matching reference design
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final locationController = Get.find<LocationController>();

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
          'Order',
          style: GoogleFonts.sora(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: Obx(() {
        final coffee = cartController.selectedCoffee.value;
        if (coffee == null) {
          return const Center(child: Text('No item selected'));
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // ─── Deliver / Pick Up Toggle ───
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.lightCard,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Obx(() => Row(
                      children: [
                        _buildToggleButton(
                          label: AppStrings.deliver,
                          isSelected: cartController.isDelivery.value,
                          onTap: () => cartController.toggleDelivery(true),
                        ),
                        _buildToggleButton(
                          label: AppStrings.pickUp,
                          isSelected: !cartController.isDelivery.value,
                          onTap: () => cartController.toggleDelivery(false),
                        ),
                      ],
                    )),
              ),

              SizedBox(height: 24.h),

              // ─── Delivery Address ───
              Obx(() {
                if (!cartController.isDelivery.value) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.deliveryAddress,
                      style: GoogleFonts.sora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Delivery Location',
                      style: GoogleFonts.sora(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      locationController.currentLocation.value,
                      style: GoogleFonts.sora(
                        fontSize: 12.sp,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        _buildActionChip(
                          icon: Icons.edit_note,
                          label: AppStrings.editAddress,
                        ),
                        SizedBox(width: 8.w),
                        _buildActionChip(
                          icon: Icons.note_add_outlined,
                          label: AppStrings.addNote,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(height: 1, color: AppColors.lightBorder),
                    SizedBox(height: 20.h),
                  ],
                );
              }),

              // ─── Order Summary ───
              Row(
                children: [
                  // Coffee image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: coffee.imageUrl.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: coffee.imageUrl,
                          width: 54.w,
                          height: 54.w,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 54.w,
                            height: 54.w,
                            color: AppColors.lightCard,
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 54.w,
                            height: 54.w,
                            color: AppColors.lightCard,
                            child: const Icon(Icons.coffee, color: AppColors.primary),
                          ),
                        )
                      : Image.asset(
                          coffee.imageUrl,
                          width: 54.w,
                          height: 54.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 54.w,
                            height: 54.w,
                            color: AppColors.lightCard,
                            child: const Icon(Icons.coffee, color: AppColors.primary),
                          ),
                        ),
                  ),
                  SizedBox(width: 14.w),

                  // Name & Size
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coffee.name,
                          style: GoogleFonts.sora(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightTextPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Obx(() => Text(
                              coffee.category,
                              style: GoogleFonts.sora(
                                fontSize: 12.sp,
                                color: AppColors.lightTextSecondary,
                              ),
                            )),
                      ],
                    ),
                  ),

                  // Quantity
                  Obx(() => QuantitySelector(
                        quantity: cartController.quantity.value,
                        onIncrement: cartController.incrementQuantity,
                        onDecrement: cartController.decrementQuantity,
                      )),
                ],
              ),

              SizedBox(height: 20.h),

              // ─── Divider ───
              Container(height: 1, color: AppColors.lightBorder),

              SizedBox(height: 20.h),

              // ─── Discount ───
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightBorder),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.discount_outlined,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        '1 Discount is Applied',
                        style: GoogleFonts.sora(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.lightTextSecondary,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // ─── Payment Summary ───
              Text(
                AppStrings.paymentSummary,
                style: GoogleFonts.sora(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              SizedBox(height: 16.h),

              Obx(() => _buildPaymentRow(
                    AppStrings.price,
                    '\$ ${cartController.subtotal.toStringAsFixed(2)}',
                  )),
              SizedBox(height: 12.h),

              Obx(() => _buildPaymentRow(
                    AppStrings.deliveryFee,
                    cartController.isDelivery.value
                        ? '\$ ${cartController.shippingCost.toStringAsFixed(2)}'
                        : 'Free',
                    strikeOriginal: cartController.isDelivery.value
                        ? '\$ 2.0'
                        : null,
                  )),
              SizedBox(height: 16.h),

              Container(
                height: 1,
                color: AppColors.lightBorder,
              ),
              SizedBox(height: 16.h),

              Obx(() => _buildPaymentRow(
                    AppStrings.total,
                    '\$ ${cartController.totalPrice.toStringAsFixed(2)}',
                    isBold: true,
                  )),

              SizedBox(height: 100.h),
            ],
          ),
        );
      }),

      // ─── Bottom: Payment Method + Order Button ───
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Payment method
            Row(
              children: [
                Icon(Icons.account_balance_wallet,
                    color: AppColors.primary, size: 22.sp),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cash/Wallet',
                      style: GoogleFonts.sora(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    Obx(() => Text(
                          '\$ ${cartController.totalPrice.toStringAsFixed(2)}',
                          style: GoogleFonts.sora(
                            fontSize: 11.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.lightTextSecondary,
                  size: 20.sp,
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Order button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'Order Placed! ☕',
                    'Your coffee is being prepared.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.success.withValues(alpha: 0.9),
                    colorText: Colors.white,
                    margin: EdgeInsets.all(16.w),
                    borderRadius: 14,
                    duration: const Duration(seconds: 3),
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    cartController.reset();
                    Get.offAllNamed('/home');
                  });
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
                  'Order',
                  style: GoogleFonts.sora(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Deliver / Pick Up toggle button
  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.sora(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Action chip
  Widget _buildActionChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightBorder),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.lightTextPrimary, size: 14.sp),
          SizedBox(width: 6.w),
          Text(
            label,
            style: GoogleFonts.sora(
              fontSize: 12.sp,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Payment summary row
  Widget _buildPaymentRow(
    String label,
    String value, {
    bool isBold = false,
    String? strikeOriginal,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.sora(
            fontSize: isBold ? 15.sp : 14.sp,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: AppColors.lightTextPrimary,
          ),
        ),
        Row(
          children: [
            if (strikeOriginal != null) ...[
              Text(
                strikeOriginal,
                style: GoogleFonts.sora(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightTextSecondary,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Text(
              value,
              style: GoogleFonts.sora(
                fontSize: isBold ? 15.sp : 14.sp,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w600,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
