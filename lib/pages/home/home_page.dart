import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../mood/onboarding_intro_page.dart';
import '../user/user_page.dart';
import '../relaxation/relaxation_page.dart';
import 'dart:io'; // for exit(0)

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.displayName = 'User!'});
  final String displayName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  
  // Overlay animation controller
  late AnimationController _overlayController;
  late Animation<Offset> _overlayOffset;
  bool _isOverlayVisible = false;
  YoutubePlayerController? _overlayYoutubeController;
  double _dragOffset = 0;
  
  // Current playing content info
  String _currentTitle = '';
  String _currentSubtitle = '';
  IconData _currentIcon = Icons.music_note;

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

  @override
  void dispose() {
    _overlayYoutubeController?.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  // Video overlay controls
  void _playVideo(String title, String subtitle, IconData icon, String videoId) {
    _overlayYoutubeController?.pause();
    _overlayYoutubeController?.dispose();

    _currentTitle = title;
    _currentSubtitle = subtitle;
    _currentIcon = icon;

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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: _buildAppDrawer(context),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);

          if (i == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OnboardingIntroPage()),
            );
          } else if (i == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RelaxationPage()),
            );
          } else if (i == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const UserPage()),
            );
          }
        },
        selectedItemColor: const Color(0xFF25424F),
        unselectedItemColor: Colors.grey[500],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_alt_outlined),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Relaxation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'User',
          )
        ],
      ),
      body: Stack(
        children: [
          _buildMainContent(),
          if (_isOverlayVisible) _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3C5C5A), Color(0xFF9DA5A9)],
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            // Top bar with menu + avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu, color: Colors.white),
                  ),
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      AssetImage('assets/avatar_placeholder.png'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Greeting
            Text(
              'Hi, ${widget.displayName}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'How do you feel today?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            // Mood chips - Now clickable to navigate to RelaxationPage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MoodChip(
                  icon: Icons.mood_bad_outlined,
                  label: 'Anxious',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RelaxationPage(
                          initialCategory: 'Anxiety reliefs',
                        ),
                      ),
                    );
                  },
                ),
                _MoodChip(
                  icon: Icons.work_outline,
                  label: 'Distracted',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RelaxationPage(
                          initialCategory: 'Overthinking detox',
                        ),
                      ),
                    );
                  },
                ),
                _MoodChip(
                  icon: Icons.self_improvement,
                  label: 'Relax',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RelaxationPage(
                          initialCategory: 'Self-love & confidence',
                        ),
                      ),
                    );
                  },
                ),
                _MoodChip(
                  icon: Icons.sentiment_very_dissatisfied,
                  label: 'Depressed',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RelaxationPage(
                          initialCategory: 'Stress & burnout',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Not sure how do you feel today?',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Let's figure it out"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const OnboardingIntroPage()),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            _RecoCard(
              title: 'Bring your focus back',
              subtitle:
                  'Listen to our most relaxing songs and gain back your focus',
              buttonText: 'Listen now',
              illustration: Icons.self_improvement,
              onButtonPressed: () {
                _playVideo(
                  'Bring your focus back',
                  'Listen to our most relaxing songs and gain back your focus',
                  Icons.self_improvement,
                  '9bZkp7q19f0', // Peaceful Piano & Rain
                );
              },
            ),
            const SizedBox(height: 14),
            _RecoCard(
              title: 'Quiet the overthinking',
              subtitle:
                  'Watch calming visuals and guided talks that help clear your busy mind',
              buttonText: 'Watch now',
              illustration: Icons.weekend_outlined,
              onButtonPressed: () {
                _playVideo(
                  'Quiet the overthinking',
                  'Watch calming visuals and guided talks that help clear your busy mind',
                  Icons.weekend_outlined,
                  '3JZ_D3ELwOQ', // Mindful meditation
                );
              },
            ),
          ],
        ),
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
                          const SizedBox(height: 12),
                          Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Video player
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
                                    : const Center(child: CircularProgressIndicator()),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Title + subtitle
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _currentSubtitle,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Seek bar
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Slider(
                                  value: _overlayYoutubeController?.value.position.inSeconds.toDouble() ?? 0,
                                  max: _overlayYoutubeController?.metadata.duration.inSeconds.toDouble() ?? 1,
                                  onChanged: (value) {
                                    _overlayYoutubeController?.seekTo(Duration(seconds: value.toInt()));
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(_overlayYoutubeController?.value.position ?? Duration.zero),
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                    Text(
                                      _formatDuration(
                                        Duration(seconds: _overlayYoutubeController?.metadata.duration.inSeconds ?? 0),
                                      ),
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                iconSize: 40,
                                icon: const Icon(Icons.replay_10, color: Color(0xFF7A9BA3)),
                                onPressed: () => _seekOverlayRelative(const Duration(seconds: -10)),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF3C5C5A),
                                ),
                                child: IconButton(
                                  iconSize: 36,
                                  icon: Icon(
                                    _overlayYoutubeController?.value.isPlaying == true
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  onPressed: _toggleOverlayPlayPause,
                                ),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                iconSize: 40,
                                icon: const Icon(Icons.forward_10, color: Color(0xFF7A9BA3)),
                                onPressed: () => _seekOverlayRelative(const Duration(seconds: 10)),
                              ),
                            ],
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

// ---------------------------------------------------------
// ⭐ DRAWER WIDGET
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
          onTap: () {
            exit(0);
          },
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _RecoCard extends StatelessWidget {
  const _RecoCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.illustration,
    required this.onButtonPressed,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final IconData illustration;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black12,
            ),
            child: Icon(illustration, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54, height: 1.3)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: onButtonPressed,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(buttonText),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      backgroundColor: Colors.black.withOpacity(0.06),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      foregroundColor: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}