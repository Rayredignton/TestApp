import 'package:flutter/material.dart';
import 'package:pawltest/core/utils/nav_bar.dart';
import 'package:pawltest/features/cart/presentation/cart_screen.dart';
import 'package:pawltest/features/feed/presentation/pages/feed_screen.dart';
import 'package:provider/provider.dart';


class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {


  @override
  void initState() {
    super.initState();

     
  }
  int _currentIndex = 0;

  final List<Widget> _pages = [

  FeedScreen(),
 CartScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
