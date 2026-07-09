import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffee_shop_app/core/constants/app_colors.dart';

/// Size selector widget — matches reference: bordered boxes, primary highlight
class SizeSelector extends StatelessWidget {
  final String selectedSize;
  final ValueChanged<String> onSizeChanged;

  const SizeSelector({
    super.key,
    required this.selectedSize,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['S', 'M', 'L'].map((size) {
        final isSelected = selectedSize == size;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSizeChanged(size),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.lightBorder,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  size,
                  style: GoogleFonts.sora(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
