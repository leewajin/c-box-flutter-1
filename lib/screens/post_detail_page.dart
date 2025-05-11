import 'package:flutter/material.dart';
import '../widgets/comment_item.dart';  // 댓글 컴포넌트 import

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            const Text(
              '노트북 수리 도와주세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 카테고리 + 작성자
            Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('수리'),
                ),
                const SizedBox(width: 8),
                const Text(
                  '사용자1',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 본문 내용
            const Text(
              '노트북이 고장났는데 어떻게 고쳐야 할지 모르겠어요. '
                  '수리 가능한 분 계시면 도와주셨으면 합니다.',
              style: TextStyle(fontSize: 16),
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
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 댓글 리스트 (지금은 예제 하나지만 ListView로 확장 가능!)
            const CommentItem(
              username: '사용자2',
              comment: '저요! 어디에 계신가요?',
              time: '58분 전',
            ),

            const Spacer(),

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
                  style: const TextStyle(fontSize: 16, color: Colors.white)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}