 // lib/features/feed/presentation/product_details.dart (updated with cart)
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/formatter_extension_methods.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pawltest/features/cart/presentation/cart_screen.dart';
import 'package:pawltest/features/feed/presentation/product_vm.dart';
import 'package:provider/provider.dart';
import 'package:pawltest/features/cart/data/cart_model.dart';
import 'package:pawltest/features/cart/presentation/cart_vm.dart';
import 'package:pawltest/features/feed/data/product_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _pageController = PageController();
  bool _isInWishlist = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showAddedToCartSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                "${widget.product.title} added to cart",
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to cart
                    Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CartScreen()));
              },
              child: Text(
                "VIEW CART",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartVm()),
      ],
      child: Consumer2<CartVm, FeedVm>(
        builder: (context, cartVm, feedVm, _) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                // App Bar with image gallery
                SliverAppBar(
                  expandedHeight: 350.h,
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        // Image gallery
                        if (widget.product.images.isNotEmpty)
                          SizedBox(
                            height: 350.h,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: widget.product.images.length,
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  imageUrl: widget.product.images[index],
                                  height: 350.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Container(
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  placeholder: (_, __) => Container(
                                    color: Colors.grey[100],
                                    child: Center(
                                      child: CupertinoActivityIndicator(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Container(
                            height: 350.h,
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50.sp,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),

                        // Gradient overlay
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Page indicator
                        if (widget.product.images.length > 1)
                          Positioned(
                            bottom: 20.h,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: widget.product.images.length,
                                effect: WormEffect(
                                  dotHeight: 8,
                                  dotWidth: 20,
                                  type: WormType.normal,
                                  activeDotColor: Colors.white,
                                  dotColor: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),

                        // Back button
                   

                        // Cart counter
                        Positioned(
                          top: 50.h,
                          right: 16.w,
                          child: Row(
                            children: [
                     
                            
                              // Cart button with badge
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                      onPressed: () {
                                 Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CartScreen()));
                                      },
                                    ),
                                  ),
                                  if (cartVm.count > 0)
                                    Positioned(
                                      top: -5,
                                      right: -5,
                                      child: Container(
                                        padding: EdgeInsets.all(4.w),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 16.sp,
                                          minHeight: 16.sp,
                                        ),
                                        child: Center(
                                          child: Text(
                                            cartVm.count.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Product details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and price
                        Text(
                          widget.product.title,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                widget.product.category,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  widget.product.rating.toString(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "₦${((widget.product.price * 1000).toInt() / 100).toString().toCurrencyString()}",
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Description
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          widget.product.description.isNotEmpty
                              ? widget.product.description
                              : "No description available for this product.",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Action buttons
                        Row(
                          children: [
                            // Wishlist button
                            Expanded(
                              child: SizedBox(
                                height: 56.h,
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isInWishlist = !_isInWishlist;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          _isInWishlist 
                                              ? "Added to wishlist" 
                                              : "Removed from wishlist",
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _isInWishlist 
                                        ? Colors.red 
                                        : Theme.of(context).primaryColor,
                                    side: BorderSide(
                                      color: _isInWishlist 
                                          ? Colors.red 
                                          : Theme.of(context).primaryColor,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _isInWishlist 
                                            ? Icons.favorite 
                                            : Icons.favorite_border,
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "Wishlist",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            
                            // Add to cart button
                            Expanded(
                              child: SizedBox(
                                height: 56.h,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final cartItem = CartItem.fromProduct(widget.product);
                                    await cartVm.addToCart(cartItem);
                                    _showAddedToCartSnackbar(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shopping_cart, size: 18.sp),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Buy now button
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: OutlinedButton(
                            onPressed: () {
                              // Navigate to checkout
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("Checkout"),
                                  content: Text("Proceed to checkout?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Order placed successfully!"),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      child: Text("Yes"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: BorderSide(color: Colors.green),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            child: Text(
                              "Buy Now",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}