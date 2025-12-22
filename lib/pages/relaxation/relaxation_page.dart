import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../home/home_page.dart';
import '../mood/onboarding_intro_page.dart';
import '../user/user_page.dart';
import 'dart:io'; // for exit(0)

// ✅ CHANGE THIS PATH to your actual services file location
import '../../services/relaxation_service.dart';

class RelaxationPage extends StatefulWidget {
  const RelaxationPage({super.key, this.initialCategory});
  
  final String? initialCategory;

  @override
  State<RelaxationPage> createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage>
    with SingleTickerProviderStateMixin {
  int _navIndex = 2; // we are on Relax tab
  int _selectedCategory = 0;

  // ✅ NEW: API Result State
  String _relaxationText = '';
  bool _isLoadingRelaxation = false;

  // Overlay animation and video player
  late AnimationController _overlayController;
  late Animation<Offset> _overlayOffset;
  bool _isOverlayVisible = false;
  YoutubePlayerController? _overlayYoutubeController;
  int _selectedItemIndex = 0;
  double _dragOffset = 0;

  // ⭐ ScrollController for category list
  final ScrollController _categoryScrollController = ScrollController();

  final List<String> _categories = const [
    'All',
    'Anxiety reliefs',
    'Overthinking detox',
    'Motivation & energy',
    'Stress & burnout',
    'Self-love & confidence',
  ];

  // ⭐ EXPANDED VIDEO LIST - Add more videos here and assign categories
  // ⭐ CHANGE THE CATEGORY VALUES to match your content
  final List<_RelaxItem> _allItems = const [
    // Anxiety reliefs videos
    _RelaxItem(
      title: 'Ocean waves',
      subtitle: 'Gentle rolling ocean and wave sounds',
      icon: Icons.waves,
      videoId: 'cB_CwY9dhrA',
      category: 'Anxiety reliefs', // ⭐ CHANGE THIS to assign category
    ),
    _RelaxItem(
      title: 'Deep Breathing Exercise',
      subtitle: 'Calm your anxiety with guided breathing',
      icon: Icons.air,
      videoId: '9bZkp7q19f0',
      category: 'Anxiety reliefs', // ⭐ CHANGE THIS to assign category
    ),
    _RelaxItem(
      title: 'Peaceful Garden Sounds',
      subtitle: 'Birds chirping in a serene garden',
      icon: Icons.park,
      videoId: '3JZ_D3ELwOQ',
      category: 'Anxiety reliefs', // ⭐ CHANGE THIS to assign category
    ),

    // Overthinking detox videos
    _RelaxItem(
      title: 'The Mindful Kind',
      subtitle: 'Gentle steps to ease your mind',
      icon: Icons.headphones,
      videoId: '3JZ_D3ELwOQ',
      category: 'Overthinking detox', // ⭐ CHANGE THIS to assign category
    ),
    _RelaxItem(
      title: 'Peaceful Piano & Rain',
      subtitle: 'Lo-fi piano with soft background rain',
      icon: Icons.piano,
      videoId: '9bZkp7q19f0',
      category: 'Overthinking detox', // ⭐ CHANGE THIS to assign category
    ),
    _RelaxItem(
      title: 'Mind Clarity Meditation',
      subtitle: 'Clear your thoughts and find peace',
      icon: Icons.spa,
      videoId: 'dQw4w9WgXcQ',
      category: 'Overthinking detox', // ⭐ CHANGE THIS to assign category
    ),

    // Motivation & energy videos
    _RelaxItem(
      title: 'Morning Energy Boost',
      subtitle: 'Uplifting music to start your day',
      icon: Icons.wb_sunny,
      videoId: '9bZkp7q19f0',
      category: 'Motivation & energy', // ⭐ CHANGE THIS to assign category
    ),
    _RelaxItem(
      title: 'Power Through Your Day',
      subtitle: 'Motivational speech and energetic beats',
      icon: Icons.bolt,
      videoId: '3JZ_D3ELwOQ',
      category: 'Motivation & energy', // ⭐ CHANGE THIS to assign category
    ),
    _RelaxItem(
      title: 'Workout Motivation Mix',
      subtitle: 'High-energy tracks to keep you moving',
      icon: Icons.fitness_center,
      videoId: 'dQw4w9WgXcQ',
      category: 'Motivation & energy', // ⭐ CHANGE THIS to assign category
    ),

    // Stress & burnout videos
    _RelaxItem(
      title: 'Forest Birds & Wind',
      subtitle: 'Soft wind and forest ambience',
      icon: Icons.forest,
      videoId: 'dQw4w9WgXcQ',
      category: 'Stress & burnout', // ⭐ CHANGE THIS to assign category
    ),
    _RelaxItem(
      title: 'Stress Relief Meditation',
      subtitle: 'Release tension and restore balance',
      icon: Icons.self_improvement,
      videoId: '9bZkp7q19f0',
      category: 'Stress & burnout', // ⭐ CHANGE THIS to assign category
    ),
    _RelaxItem(
      title: 'Calm Piano for Work',
      subtitle: 'Gentle melodies to reduce workplace stress',
      icon: Icons.piano_outlined,
      videoId: '3JZ_D3ELwOQ',
      category: 'Stress & burnout', // ⭐ CHANGE THIS to assign category
    ),

    // Self-love & confidence videos
    _RelaxItem(
      title: 'Positive Affirmations',
      subtitle: 'Build confidence with daily affirmations',
      icon: Icons.favorite,
      videoId: 'dQw4w9WgXcQ',
      category: 'Self-love & confidence', // ⭐ CHANGE THIS to assign category
    ),
    _RelaxItem(
      title: 'Surah Ar-Rahman',
      subtitle: 'Recitation by Mishary Al Afasy',
      icon: Icons.menu_book,
      videoId: 'dQw4w9WgXcQ',
      category: 'Self-love & confidence', // ⭐ CHANGE THIS to assign category
    ),
    _RelaxItem(
      title: 'Self-Care Meditation',
      subtitle: 'Love yourself and embrace inner peace',
      icon: Icons.spa_outlined,
      videoId: '9bZkp7q19f0',
      category: 'Self-love & confidence', // ⭐ CHANGE THIS to assign category
    ),

    // Add more videos below as needed
    // ⭐ COPY THIS TEMPLATE to add new videos:
    /*
    _RelaxItem(
      title: 'Your Video Title',
      subtitle: 'Your video description',
      icon: Icons.your_icon_here,
      videoId: 'YouTubeVideoID',
      category: 'Category Name', // Must match one of the categories above
    ),
    */
  ];

  // ⭐ FILTER FUNCTION - Returns filtered list based on selected category
  List<_RelaxItem> get _filteredItems {
    if (_selectedCategory == 0) {
      // "All" category - show everything
      return _allItems;
    } else {
      // Filter by selected category
      final categoryName = _categories[_selectedCategory];
      return _allItems.where((item) => item.category == categoryName).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _overlayOffset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _overlayController, curve: Curves.easeOut));
    
    // ⭐ Set initial category if provided from HomePage
    if (widget.initialCategory != null) {
      final index = _categories.indexOf(widget.initialCategory!);
      if (index != -1) {
        _selectedCategory = index;
      }
    }
  }

  // ⭐ Scroll to selected category chip
  void _scrollToCategory(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_categoryScrollController.hasClients) {
        // For first two items, scroll to start
        if (index <= 1) {
          _categoryScrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return;
        }
        
        // Calculate approximate position to scroll to
        final itemWidth = 150.0; // approximate width of each chip
        final spacing = 8.0;
        final targetPosition = ((itemWidth + spacing) * (index - 1));
        
        // Get the max scroll extent
        final maxScroll = _categoryScrollController.position.maxScrollExtent;
        
        // Calculate position, keeping some items visible
        final scrollTo = targetPosition > maxScroll ? maxScroll : targetPosition;
        
        _categoryScrollController.animateTo(
          scrollTo,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _callRelaxationApi() async {
    setState(() {
      _isLoadingRelaxation = true;
      _relaxationText = '';
    });

    try {
      final result = await RelaxationService.generateRelaxation(
        mood: 'calm',
      );

      if (!mounted) return;
      setState(() {
        _relaxationText = result;
        _isLoadingRelaxation = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _relaxationText = 'Error: $e';
        _isLoadingRelaxation = false;
      });
    }
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
    
    // ⭐ IMPROVED: Better loading flags for faster playback
    _overlayYoutubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        forceHD: true, 
        disableDragSeek: false,
        loop: false,
      ),
    );

    setState(() {
      _isOverlayVisible = true;
    });
    _overlayController.forward();
    
    // ⭐ DEBUG: Print video ID to console
    print('🎬 Attempting to play video: $videoId');
  }

  void _hideOverlay() {
    _overlayController.reverse().then((_) {
      setState(() {
        _isOverlayVisible = false;
        _dragOffset = 0;

        // Optional: clear result when closing overlay
        _relaxationText = '';
        _isLoadingRelaxation = false;
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
    _categoryScrollController.dispose(); // ⭐ Dispose scroll controller
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

                    // category chips - Now with proper draggable configuration
                    SizedBox(
                      height: 40,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          // Allow scroll notifications to propagate
                          return false;
                        },
                        child: ListView.separated(
                          controller: _categoryScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const AlwaysScrollableScrollPhysics(), // ⭐ Force scrollable even with few items
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          itemCount: _categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, idx) {
                            final isSelected = idx == _selectedCategory;
                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedCategory = idx);
                                _scrollToCategory(idx);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.16),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    _categories[idx],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? const Color(0xFF3C5C5A) : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Listen or Watch:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        Text(
                          '${_filteredItems.length} videos',
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ⭐ CARDS LIST - Now uses _filteredItems instead of _items
                    Expanded(
                      child: _filteredItems.isEmpty
                          ? const Center(
                              child: Text(
                                'No videos in this category',
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.only(bottom: 12),
                              itemCount: _filteredItems.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
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
    final currentItem = _filteredItems[_selectedItemIndex];
    
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
                                   ? YoutubePlayerBuilder(
                                    player: YoutubePlayer(
                                      controller: _overlayYoutubeController!,
                                      showVideoProgressIndicator: true,
                                      ),
                                      builder: (context, player) {
                                        return player;
                                        },
                                        )

                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Button to call API + show result
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  onPressed: _isLoadingRelaxation ? null : _callRelaxationApi,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3C5C5A),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: _isLoadingRelaxation
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : const Text(
                                          'Generate Relaxation Text',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                        ),
                                ),
                                const SizedBox(height: 12),

                                if (_relaxationText.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Text(
                                      _relaxationText,
                                      style: const TextStyle(fontSize: 13, height: 1.4),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // title/subtitle
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
                                        currentItem.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        currentItem.subtitle,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
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

// ⭐ UPDATED _RelaxItem CLASS - Now includes category field
class _RelaxItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String videoId;
  final String category; // ⭐ NEW: Category field for filtering

  const _RelaxItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.videoId,
    required this.category, // ⭐ Must be provided when creating items
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