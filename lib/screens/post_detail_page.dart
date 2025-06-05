import 'package:flutter/material.dart';
import '../widgets/comment_item.dart'; // 댓글 컴포넌트 import

class PostDetailPage extends StatefulWidget {
  final String title;
  final String category;
  final String author;
  final String content;

  const PostDetailPage({
    super.key,
    required this.title,
    required this.category,
    required this.author,
    required this.content,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  // 댓글 목록을 저장할 리스트!
  final List<Map<String, String>> _comments = [
    {
      'username': '사용자2',
      'comment': '저요! 어디에 계신가요?',
      'time': '58분 전',
    },
  ];

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _comments.insert(0, {
          'username': '나', // 나중에 로그인 정보로 바꿔도 좋아요!
          'comment': text,
          'time': '방금 전',
        });
        _commentController.clear(); // 입력창 비우기
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              widget.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 카테고리 + 작성자
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(widget.category),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 본문
            Text(
              widget.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/laptop.jpg',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // 댓글 입력창
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 작성하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addComment,
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 댓글 리스트 보여주기
            ..._comments.map((comment) {
              return CommentItem(
                username: comment['username'] ?? '',
                comment: comment['comment'] ?? '',
                time: comment['time'] ?? '',
              );
            }).toList(),

            const SizedBox(height: 24),

            // 쪽지 보내기 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 나중에 쪽지 보내기 기능 연결
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  '쪽지 보내기',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}