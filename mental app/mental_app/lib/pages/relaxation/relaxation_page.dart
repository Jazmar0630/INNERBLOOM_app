<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../home/home_page.dart';
import '../mood/onboarding_intro_page.dart';
import '../user/user_page.dart';
=======
 import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../mood/onboarding_intro_page.dart';
import '../user/user_page.dart';
import 'dart:io'; // for exit(0)
>>>>>>> 8ffcd72b6cd345cd7401c9d5343045cf54dfd65a

class RelaxationPage extends StatefulWidget {
  const RelaxationPage({super.key});

  @override
  State<RelaxationPage> createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage>
    with SingleTickerProviderStateMixin {
  int _navIndex = 2; // we are on Relax tab
  int _selectedCategory = 0;

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

  // overlay + player state
  late final AnimationController _overlayController;
  late final Animation<Offset> _overlayOffset;
  bool _isOverlayVisible = false;
  YoutubePlayerController? _overlayYoutubeController;
  int _overlayCurrentIndex = 0;

  // sample placeholder video ids — replace with your real ones later
  final List<String> _videoIds = [
    'dQw4w9WgXcQ',
    '9bZkp7q19f0',
    '3JZ_D3ELwOQ',
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

  void _showOverlayForIndex(int index) {
    // clean up previous controller
    _overlayYoutubeController?.pause();
    _overlayYoutubeController?.dispose();

    _overlayCurrentIndex = index.clamp(0, _videoIds.length - 1);
    _overlayYoutubeController = YoutubePlayerController(
      initialVideoId: _videoIds[_overlayCurrentIndex],
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
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

      // ✅ ADD DRAWER HERE
      drawer: _buildAppDrawer(context),

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
            child: Stack(
              children: [
                // Main content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
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
                              child: Text(_categories[idx], style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? const Color(0xFF3C5C5A) : Colors.white)),
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
                          return _RelaxCard(item: item, onPlay: () => _showOverlayForIndex(index % _videoIds.length));
                        },
                      ),
=======
                    // ✅ DRAWER ICON THAT OPENS MENU
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
>>>>>>> 8ffcd72b6cd345cd7401c9d5343045cf54dfd65a
                    ),
                  ],
                ),

                // overlay backdrop
                if (_isOverlayVisible)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _hideOverlay,
                      child: Container(color: Colors.black54),
                    ),
                  ),

                // overlay sheet
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SlideTransition(
                    position: _overlayOffset,
                    child: SafeArea(
                      top: false,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                        ),
<<<<<<< HEAD
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(child: Text(_items[_overlayCurrentIndex].title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                                  IconButton(onPressed: _hideOverlay, icon: const Icon(Icons.close)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: _overlayYoutubeController != null
                                  ? YoutubePlayer(controller: _overlayYoutubeController!, showVideoProgressIndicator: true)
                                  : const Center(child: CircularProgressIndicator()),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(iconSize: 32, icon: const Icon(Icons.replay_10), onPressed: () => _seekOverlayRelative(const Duration(seconds: -10))),
                                  IconButton(iconSize: 48, icon: Icon(_overlayYoutubeController?.value.isPlaying == true ? Icons.pause_circle_filled : Icons.play_circle_fill), onPressed: _toggleOverlayPlayPause),
                                  IconButton(iconSize: 32, icon: const Icon(Icons.forward_10), onPressed: () => _seekOverlayRelative(const Duration(seconds: 10))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
=======
                      );
                    },
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Listen or Watch:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                // vertical scrolling cards
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return _RelaxCard(item: item);
                    },
>>>>>>> 8ffcd72b6cd345cd7401c9d5343045cf54dfd65a
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
<<<<<<< HEAD
=======

      // bottom nav
>>>>>>> 8ffcd72b6cd345cd7401c9d5343045cf54dfd65a
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
}

// ---------------------------------------------------------
// ✅ DRAWER WIDGET (same as HomePage drawer)
// ---------------------------------------------------------
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

// ---------------------------------------------------------

class _RelaxItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const _RelaxItem({required this.title, required this.subtitle, required this.icon});
}

class _RelaxCard extends StatelessWidget {
  final _RelaxItem item;
  final VoidCallback? onPlay;

  const _RelaxCard({required this.item, this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
<<<<<<< HEAD
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
=======
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
>>>>>>> 8ffcd72b6cd345cd7401c9d5343045cf54dfd65a
      child: Row(
        children: [
          Container(width: 50, height: 50, decoration: BoxDecoration(color: const Color(0xFF3C5C5A).withOpacity(0.1), shape: BoxShape.circle), child: Icon(item.icon, color: const Color(0xFF3C5C5A))),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(item.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.2)),
            ]),
          ),
          const SizedBox(width: 6),
<<<<<<< HEAD
          GestureDetector(
            onTap: onPlay,
            child: Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFF3C5C5A), shape: BoxShape.circle), child: const Icon(Icons.play_arrow, size: 22, color: Colors.white)),
=======
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF3C5C5A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow,
                size: 20, color: Colors.white),
>>>>>>> 8ffcd72b6cd345cd7401c9d5343045cf54dfd65a
          ),
        ],
      ),
    );
  }
}
