import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../mood/mood_appreciation.dart';
import '../relaxation/video_player_page.dart';

class MoodResultPage extends StatefulWidget {
  const MoodResultPage({super.key});

  @override
  State<MoodResultPage> createState() => _MoodResultPageState();
}

class _MoodResultPageState extends State<MoodResultPage> {
  late YoutubePlayerController _ytController;

  final List<_RelaxItem> _items = const [
    _RelaxItem(
      title: 'Ocean waves',
      subtitle: 'Gentle rolling ocean and wave sounds',
      icon: Icons.waves,
    ),
    _RelaxItem(
      title: 'Peaceful Piano & Rain',
      subtitle: 'Lo-fi piano with soft background rain',
      icon: Icons.piano,
    ),
    _RelaxItem(
      title: 'The Mindful Kind',
      subtitle: 'Gentle steps to ease your mind',
      icon: Icons.headphones,
    ),
    _RelaxItem(
      title: 'Forest Birds & Wind',
      subtitle: 'Soft wind and forest ambience',
      icon: Icons.park,
    ),
    _RelaxItem(
      title: 'Surah Ar-Rahman',
      subtitle: 'Recitation by Mishary Al Afasy',
      icon: Icons.menu_book,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // 👉 replace this URL with any YouTube link you like
    const url = 'https://www.youtube.com/shorts/c_c2NmiDr-I?feature=share';

    _ytController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _ytController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3C5C5A), Color(0xFF9DA5A9)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {},
                    ),
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search music, audio, videos',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "It looks like you've been through a lot lately. "
                  "Here's something that can help you feel better and boost back your confidence:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

// ⭐ YOUTUBE THUMBNAIL HERE ⭐
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VideoPlayerPage()),
    );
  },
  child: Stack(
    alignment: Alignment.center,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          "https://img.youtube.com/vi/2OEL4P1Rz04/maxresdefault.jpg",
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      const Icon(Icons.play_circle_fill,
          size: 70, color: Colors.white),
    ],
  ),
),


                const SizedBox(height: 16),
                // 🧘 Embedded YouTube relaxation video
                SizedBox(
  height: 220, // try 180–240 until you like it
  width: double.infinity,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: YoutubePlayer(
      controller: _ytController,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.white,
    ),
  ),
),

                const SizedBox(height: 16),

                // relaxation list
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return _RelaxCard(item: item);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // bottom right button → Mood Appreciation Page
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3C5C5A),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MoodAppreciationPage()),
          );
        },
        child: const Icon(Icons.favorite, color: Colors.white),
      ),
    );
  }
}

class _RelaxItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const _RelaxItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _RelaxCard extends StatelessWidget {
  final _RelaxItem item;
  const _RelaxCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF3C5C5A).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: const Color(0xFF3C5C5A)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF3C5C5A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              size: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
