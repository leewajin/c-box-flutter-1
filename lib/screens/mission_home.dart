import 'package:flutter/material.dart';
import '../widgets/category_tab_bar.dart';
import '../widgets/post_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/hot_post_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/custom_app_bar_title.dart';
import '../screens/post_detail_page.dart';
import '../screens/post_create_page.dart';

class MissionHome extends StatefulWidget {
  const MissionHome({super.key});

  @override
  State<MissionHome> createState() => _MissionHomeState();
}

class _MissionHomeState extends State<MissionHome> {
  final List<Map<String, dynamic>> posts = [
    {
      'category': '수업',
      'title': '이산구조 시험 언제임?',
      'comments': 3,
      'createdAt': DateTime.now().subtract(const Duration(minutes: 30)),
    },
    {
      'category': '요청',
      'title': '공대 3층 화장실에 휴지가 없어요 ㅜㅜㅜ',
      'comments': 1,
      'createdAt': DateTime.now().subtract(const Duration(hours:2)),
    },
  ];

  void _navigateToCreatePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PostCreatePage()),
    );

    if (!mounted) return;

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        posts.insert(0, result); // 새 글을 맨 위에 추가!
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시물이 등록되었습니다!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: MainContent(posts: posts),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePage,
        backgroundColor: Colors.indigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add, size: 32, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class MainContent extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  const MainContent({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    final hotPosts = [
      {'title': '공대 3층 화장실에 휴지가 없어요 ㅜㅜㅜ', 'subtitle': '댓글 12'},
      {'title': '자바 스터디 하실 분 구합니다', 'subtitle': '댓글 8'},
      {'title': '3-5시 충전기 빌려주실 분?', 'subtitle': '댓글 20'},
    ];

    return Column(
      children: [
        // 핫게시글
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: hotPosts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, idx) {
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
        const CustomSearchBar(),
        const CategoryTabBar(categories: ['전체', '요청', '수업', '기타']),

        // 동적으로 게시글 렌더링
        Expanded(
          child: posts.isEmpty
            ? const Center(child: Text('게시글이 없습니다.'))
            : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                category: post['category'],
                title: post['title'],
                comments: post['comments'] ?? 0,
                createdAt: post['createdAt'] is String
                    ? DateTime.parse(post['createdAt'])
                    : post['createdAt'] as DateTime,
              );
            },
          ),
        ),
      ],
    );
  }
}


