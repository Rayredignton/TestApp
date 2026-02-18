import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pawltest/features/feed/presentation/product_vm.dart';
import 'package:provider/provider.dart';


class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavBar({Key? key, required this.currentIndex, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedVm>(
      builder: (context, baseVM, child) {
        return Padding(
          padding: EdgeInsets.only(
            left: 30.w,
            right: 30.w,
            top: 20.h,
            bottom: 35.h,
          ),
          child: Container(
            height: 65.h,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(40.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, Icon(Icons.home), "Feed", 0),
                _buildNavItem(context,   Icon(Icons.shopping_cart), "Cart", 1),
          
              
            
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    Icon icon,
    String label,
    int index, [
    Color? color,
  ]) {
    bool selected = index == currentIndex;
    final selectedColor = color ?? Theme.of(context).primaryColor;
    final selectedColorText = Theme.of(context).textTheme.bodyLarge?.color;
    final unselectedColor =
        color ?? Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: selected ? selectedColorText : unselectedColor,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
