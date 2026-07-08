import 'package:flutter/material.dart';
import '../../community/screens/community_feed_screen.dart';
import '../../qa_support/screens/qna_list_screen.dart';
import '../../experts/screens/expert_list_screen.dart';
import '../../profile/screens/profile_screen.dart';
import 'home_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    CommunityFeedScreen(),
    QnaListScreen(),
    ExpertListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_rounded), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.forum_rounded), label: 'Q&A'),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent_rounded), label: 'Experts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
