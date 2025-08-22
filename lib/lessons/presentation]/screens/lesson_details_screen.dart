import 'package:flutter/material.dart';
import '../../../comment/presentation/widget/comments_tab.dart';
import '../../../quiz/presentation/screens/quiz_screen.dart';
import '../../data/lesson_model.dart';
import '../../widgets/lesson_video_player.dart';

class LessonDetailsScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailsScreen({Key? key, required this.lesson}) : super(key: key);

  Future<dynamic> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await _launchUrl(url as String)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (lesson.videoUrl != null &&
                          lesson.videoUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LessonVideoPlayer(videoUrl: lesson.videoUrl!),
                        )
                      else
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text('No video available'),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        lesson.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  const TabBar(
                    tabs: [
                      Tab(text: 'Summary (PDF)'),
                      Tab(text: 'Comments'),
                    ],
                    labelColor: Colors.black,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildSummaryTab(),
              CommentsTab(lessonId: lesson.id),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff29a4d9),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => QuizScreen(lessonId: lesson.id),
              ),
            );
          },
          child: const Text(
            'Start Test',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryTab() {
    if (lesson.summaryUrl != null && lesson.summaryUrl!.isNotEmpty) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Open Summary PDF'),
          onPressed: () {
            _launchUrl(lesson.summaryUrl!);
          },
        ),
      );
    } else {
      return const Center(child: Text('No summary available for this lesson.'));
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
