import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../home/home_page.dart';
import '../mood/onboarding_intro_page.dart';
import '../user/user_page.dart';
import 'dart:io'; // for exit(0)
import '../services/relaxation_service.dart';
class RelaxationPage extends StatefulWidget {
  const RelaxationPage({super.key});

  @override
  State<RelaxationPage> createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage>
    with SingleTickerProviderStateMixin {
  int _navIndex = 2; // we are on Relax tab
  int _selectedCategory = 0;
  
  // Overlay animation and video player
  late AnimationController _overlayController;
  late Animation<Offset> _overlayOffset;
  bool _isOverlayVisible = false;
  YoutubePlayerController? _overlayYoutubeController;
  int _selectedItemIndex = 0;
  double _dragOffset = 0;

  final List<String> _categories = const [
    'All',
    'Anxiety reliefs',
    'Overthinking detox',
    'Motivation & energy',
    'Stress & burnout',
    'Self-love & confidence',
  ];

  final List<_RelaxItem> _items = const [
    _RelaxItem(
      title: 'Ocean waves',
      subtitle: 'Gentle rolling ocean and wave sounds',
      icon: Icons.waves,
      videoId: 'dQw4w9WgXcQ',
    ),
    _RelaxItem(
      title: 'Peaceful Piano & Rain',
      subtitle: 'Lo-fi piano with soft background rain',
      icon: Icons.piano,
      videoId: '9bZkp7q19f0',
    ),
    _RelaxItem(
      title: 'The Mindful Kind',
      subtitle: 'Gentle steps to ease your mind',
      icon: Icons.headphones,
      videoId: '3JZ_D3ELwOQ',
    ),
    _RelaxItem(
      title: 'Forest Birds & Wind',
      subtitle: 'Soft wind and forest ambience',
      icon: Icons.park,
      videoId: 'dQw4w9WgXcQ',
    ),
    _RelaxItem(
      title: 'Surah Ar-Rahman',
      subtitle: 'Recitation by Mishary Al Afasy',
      icon: Icons.menu_book,
      videoId: 'dQw4w9WgXcQ',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _overlayOffset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _overlayController, curve: Curves.easeOut));
  }

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    setState(() => _navIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingIntroPage()));
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserPage()));
        break;
    }
  }

  void _playVideo(int index, String videoId) {
    _overlayYoutubeController?.pause();
    _overlayYoutubeController?.dispose();

    _selectedItemIndex = index;
    _overlayYoutubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    setState(() {
      _isOverlayVisible = true;
    });
    _overlayController.forward();
  }

  void _hideOverlay() {
    _overlayController.reverse().then((_) {
      setState(() {
        _isOverlayVisible = false;
        _dragOffset = 0;
      });
      _overlayYoutubeController?.pause();
      _overlayYoutubeController?.dispose();
      _overlayYoutubeController = null;
    });
  }

  void _toggleOverlayPlayPause() {
    final c = _overlayYoutubeController;
    if (c == null) return;
    if (c.value.isPlaying) {
      c.pause();
    } else {
      c.play();
    }
    setState(() {});
  }

  void _seekOverlayRelative(Duration offset) {
    final c = _overlayYoutubeController;
    if (c == null) return;
    final pos = c.value.position;
    c.seekTo(pos + offset);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _overlayYoutubeController?.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: _buildAppDrawer(context),
      body: Stack(
        children: [
          Container(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Search
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search music, audio, videos',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text('Categories', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 10),

                    // category chips
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, idx) {
                          final isSelected = idx == _selectedCategory;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = idx),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : Colors.white.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _categories[idx],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? const Color(0xFF3C5C5A) : Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 22),
                    const Text('Listen or Watch:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 12),

                    // Cards list
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 12),
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return _RelaxCard(
                            item: item,
                            onPlay: () => _playVideo(index, item.videoId),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Video overlay
          if (_isOverlayVisible) _buildOverlay(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _navIndex,
        onTap: _onNavTap,
        selectedItemColor: const Color(0xFF25424F),
        unselectedItemColor: Colors.grey[500],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology_alt_outlined), label: 'Mood'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Relaxation'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'User'),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: _hideOverlay,
        child: Container(
          color: Colors.black26,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _overlayOffset,
              child: GestureDetector(
                onTap: () {},
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _dragOffset += details.delta.dy;
                  });
                },
                onVerticalDragEnd: (details) {
                  if (_dragOffset > 100) {
                    _hideOverlay();
                  } else {
                    setState(() {
                      _dragOffset = 0;
                    });
                  }
                },
                child: Transform.translate(
                  offset: Offset(0, _dragOffset),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height * 0.84,
                    margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onVerticalDragUpdate: (details) {
                              setState(() {
                                _dragOffset += details.delta.dy;
                              });
                            },
                            onVerticalDragEnd: (details) {
                              if (_dragOffset > 100) {
                                _hideOverlay();
                              } else {
                                setState(() {
                                  _dragOffset = 0;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.grab,
                                child: Container(
                                  width: 40,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(2.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFF3C5C5A),
                                    width: 2,
                                  ),
                                ),
                                height: 240,
                                child: _overlayYoutubeController != null
                                    ? YoutubePlayer(
                                        controller: _overlayYoutubeController!,
                                        showVideoProgressIndicator: true,
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _items[_selectedItemIndex].title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _items[_selectedItemIndex].subtitle,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey[400]!,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.favorite_outline,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 4,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 6,
                                    ),
                                    activeTrackColor: const Color(0xFF3C5C5A),
                                    inactiveTrackColor: Colors.grey[300],
                                  ),
                                  child: Slider(
                                    value: _overlayYoutubeController
                                            ?.value.position.inSeconds
                                            .toDouble() ??
                                        0,
                                    max: _overlayYoutubeController
                                            ?.metadata.duration.inSeconds
                                            .toDouble() ??
                                        1,
                                    onChanged: (value) {
                                      _overlayYoutubeController?.seekTo(
                                        Duration(seconds: value.toInt()),
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(
                                        _overlayYoutubeController?.value.position ??
                                            Duration.zero,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(
                                        Duration(
                                          seconds: _overlayYoutubeController
                                                  ?.metadata.duration.inSeconds ??
                                              0,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  iconSize: 40,
                                  icon: const Icon(
                                    Icons.replay_10,
                                    color: Color(0xFF7A9BA3),
                                  ),
                                  onPressed: () => _seekOverlayRelative(
                                    const Duration(seconds: -10),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF3C5C5A),
                                  ),
                                  child: IconButton(
                                    iconSize: 36,
                                    icon: Icon(
                                      _overlayYoutubeController?.value.isPlaying ==
                                              true
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPressed: _toggleOverlayPlayPause,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  iconSize: 40,
                                  icon: const Icon(
                                    Icons.forward_10,
                                    color: Color(0xFF7A9BA3),
                                  ),
                                  onPressed: () => _seekOverlayRelative(
                                    const Duration(seconds: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Drawer Widget
Widget _buildAppDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Color(0xFF3C5C5A)),
          child: Text(
            'InnerBloom',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help & Support'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy Policy'),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app, color: Colors.red),
          title: const Text(
            'Exit App',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => exit(0),
        ),
      ],
    ),
  );
}

class _RelaxItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String videoId;

  const _RelaxItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.videoId,
  });
}

class _RelaxCard extends StatelessWidget {
  final _RelaxItem item;
  final VoidCallback? onPlay;

  const _RelaxCard({required this.item, this.onPlay});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlay,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onPlay,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF3C5C5A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow, size: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}