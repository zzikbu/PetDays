import 'package:flutter/material.dart';
import 'package:pet_log/components/error_dialog_widget.dart';
import 'package:pet_log/exceptions/custom_exception.dart';
import 'package:pet_log/providers/user/user_provider.dart';
import 'package:pet_log/screens/feed/feed_home_screen.dart';
import 'package:pet_log/screens/home/home_screen.dart';
import 'package:pet_log/screens/mypage/mypage_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// SingleTickerProviderStateMixin: 애니메이션을 부드럽게 처리하기 위한
class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 1,
    );
    _getProfile(); // 접속 중인 사용자의 정보 상태관리 저장
  }

  void bottomNavigationItemOnTab(int index) {
    setState(() {
      tabController.index = index;
    });
  }

  @override
  void dispose() {
    tabController.dispose(); // tabController도 dispose 해줘야 메모리에서 사라짐
    super.dispose();
  }

  // 접속 중인 사용자의 정보 상태관리 저장
  // 매번 user 데이터를 가져오는 것은 비효율이기 때문
  Future<void> _getProfile() async {
    try {
      await context.read<UserProvider>().getUserInfo();
    } on CustomException catch (e) {
      errorDialogWidget(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: TabBarView(
          controller: tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            FeedHomeScreen(),
            HomeScreen(),
            MypagePageScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabController.index,
          onTap: (value) {
            bottomNavigationItemOnTab(value);
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.feed_outlined),
              label: "피드",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "홈",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "MY"),
          ],
        ),
      ),
    );
  }
}
