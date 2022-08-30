import 'package:flutter/material.dart';
import 'package:go_live/providers/user_provider.dart';
import 'package:go_live/screens/feed_screen.dart';
import 'package:go_live/screens/go_live_screen.dart';
import 'package:go_live/utils/colors.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  List<Widget> pages = [
    const FeedScreen(),
    const GoLiveScreen(),
    const Center(
      child: Text('Browser'),
    )
  ];

  onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: buttonColor,
        unselectedItemColor: primaryColor,
        unselectedFontSize: 12,
        backgroundColor: backgroundColor,
        onTap: onPageChange,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: "Following",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_rounded,
            ),
            label: "Go Live",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy),
            label: "Browse",
          ),
        ],
      ),
      body: pages[_page],
    );
  }
}
