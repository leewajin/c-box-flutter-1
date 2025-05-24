import 'package:flutter/material.dart';
import '../widgets/category_tab.dart';
import '../widgets/post_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../screens/message_list_page.dart';  // ✉️ 쪽지 목록 화면 import
import '../widgets/hot_post_card.dart';
import '../screens/post_detail_page.dart';

class MissionHome extends StatelessWidget {
  const MissionHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title을 const Row → Row로 변경 (IconButton 때문에)
        title: Row(
          children: [
            const Text(
              'C:BOX',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Spacer(),

            // 알림 버튼 + 배지
            Stack(
              children: [
                const Icon(Icons.notifications_none),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: const Text(
                      '1',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),

            //쪽지버튼
            IconButton(
              icon: const Icon(Icons.mail_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MessageListPage(),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const MainContent(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 1) 핫게시글 데이터 선언
    final hotPosts = [
      {'title': '핫게시글1', 'subtitle': '댓글 12'},
      {'title': '핫게시글2', 'subtitle': '댓글 8'},
      {'title': '핫게시글3', 'subtitle': '댓글 20'},
    ];

    return Column(
      children: [
        // 2) 핫게시글 섹션
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: hotPosts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, idx) {
              // 이 안에서만 post 변수를 사용할 수 있습니다!
              final post = hotPosts[idx];

              return HotPostCard(
                title: post['title']!,
                subtitle: post['subtitle']!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PostDetailPage()),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // 2) 검색창
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: '검색',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),

        // 3) 카테고리 탭
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CategoryTab(title: '전체', isSelected: true),
              CategoryTab(title: '알바'),
              CategoryTab(title: '같이 하기'),
              CategoryTab(title: '정보 요청'),
            ],
          ),
        ),
        SizedBox(height: 16),

        // 4) 게시글 리스트
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              PostCard(category: '알바', title: '제목', comments: 3),
              SizedBox(height: 10),
              PostCard(category: '정보 요청', title: '정보', comments: 1),
            ],
          ),
        ),
      ],
    );
  }
}


