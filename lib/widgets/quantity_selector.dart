import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffee_shop_app/core/constants/app_colors.dart';

/// Quantity selector widget — light theme with +/- buttons
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decrement
        _buildButton(
          icon: Icons.remove,
          onTap: onDecrement,
          enabled: quantity > 1,
        ),

        // Quantity
        Container(
          width: 36.w,
          alignment: Alignment.center,
          child: Text(
            '$quantity',
            style: GoogleFonts.sora(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ),

        // Increment
        _buildButton(
          icon: Icons.add,
          onTap: onIncrement,
          enabled: true,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: enabled ? AppColors.lightBorder : AppColors.lightCard,
          ),
        ),
        child: Icon(
          icon,
          size: 14.sp,
          color: enabled ? AppColors.lightTextPrimary : AppColors.lightTextMuted,
        ),
      ),
    );
  }
}
