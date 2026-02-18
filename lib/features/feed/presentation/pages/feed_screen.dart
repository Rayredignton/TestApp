import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/formatter_extension_methods.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pawltest/features/feed/presentation/product_vm.dart';
import 'package:pawltest/features/feed/presentation/widgets/product_details.dart';
import 'package:provider/provider.dart';
import 'package:pawltest/features/feed/data/product_model.dart';

import 'package:pawltest/features/feed/presentation/widgets/offline_widget.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedVm(),
      child: Consumer<FeedVm>(
        builder: (_, vm, __) {
          return Scaffold(
            body: Stack(
              children: [
                CustomScrollView(
                  controller: vm.scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(height: 60.h),
                    ),
                    SliverToBoxAdapter(
                      child: _Header(),
                    ),
                  
                    SliverToBoxAdapter(
                      child: _CategoriesHeader(),
                    ),
                    SliverToBoxAdapter(
                      child: _CategoriesList(),
                    ),
                    SliverToBoxAdapter(
                      child: _ProductsHeader(),
                    ),
                    _ProductsGrid(),
                    if (vm.loading)
                      const SliverToBoxAdapter(
                        child: _BottomLoader(),
                      ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 80.h),
                    ),
                  ],
                ),
                  const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: OfflineBanner(),
              ),
              ],
            ),
            
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, 👋",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                "Let's shop!",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/100',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Categories",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "See all",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FeedVm>(context);
    
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: vm.categories.length,
        itemBuilder: (ctx, i) {
          final cat = vm.categories[i];
          final isSelected = vm.selectedCategory == cat;
          
          return GestureDetector(
            onTap: () => vm.selectCategory(cat),
            child: Container(
              width: 80.w,
              margin: EdgeInsets.only(right: 12.w),
              child: Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Theme.of(context).primaryColor 
                          : Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.category,
                        color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                        size: 30.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    cat == 'all' ? 'All' : cat,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FeedVm>(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            vm.selectedCategory == 'all' 
                ? "Featured Products" 
                : "${vm.selectedCategory} Products",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (vm.selectedCategory != 'all')
            TextButton(
              onPressed: () => vm.selectCategory('all'),
              child: Text(
                "View all",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FeedVm>(context);
    
    if (vm.items.isEmpty && vm.loading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (vm.items.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40.h),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 60.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  "No products found",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
        ),
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            if (i >= vm.items.length) return null;
            return _ProductCard(product: vm.items[i]);
          },
          childCount: vm.items.length,
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                    ),
                  ),
                  placeholder: (_, __) => Container(
                    color: Colors.grey[100],
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14.sp,
                              color: Colors.amber[700],
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              product.rating.toString(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "₦${((product.price * 1000).toInt() / 100).toString().toCurrencyString()}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}