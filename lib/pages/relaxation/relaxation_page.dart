import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../home/home_page.dart';
import '../mood/onboarding_intro_page.dart';
import '../user/user_page.dart';
import '../widgets/app_drawer.dart';
import '../widgets/video_player_overlay.dart'; // ADD THIS IMPORT

import '../../services/relaxation_service.dart';

class RelaxationPage extends StatefulWidget {
  const RelaxationPage({super.key, this.initialCategory});

  final String? initialCategory;

  @override
  State<RelaxationPage> createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage> {
  int _navIndex = 2;
  int _selectedCategory = 0;

  final ScrollController _categoryScrollController = ScrollController();

  final List<String> _categories = const [
    'All',
    'Anxiety reliefs',
    'Overthinking detox',
    'Motivation & energy',
    'Stress & burnout',
    'Self-love & confidence',
  ];

  final List<_RelaxItem> _allItems = const [
    _RelaxItem(
      title: 'Ocean waves',
      subtitle: 'Gentle rolling ocean and wave sounds',
      icon: Icons.waves,
      videoId: 'cB_CwY9dhrA',
      category: 'Anxiety reliefs',
    ),
    _RelaxItem(
      title: 'Deep Breathing Exercise',
      subtitle: 'Calm your anxiety with guided breathing',
      icon: Icons.air,
      videoId: '9bZkp7q19f0',
      category: 'Anxiety reliefs',
    ),
    _RelaxItem(
      title: 'Peaceful Garden Sounds',
      subtitle: 'Birds chirping in a serene garden',
      icon: Icons.park,
      videoId: '3JZ_D3ELwOQ',
      category: 'Anxiety reliefs',
    ),

    _RelaxItem(
      title: 'The Mindful Kind',
      subtitle: 'Gentle steps to ease your mind',
      icon: Icons.headphones,
      videoId: '3JZ_D3ELwOQ',
      category: 'Overthinking detox',
    ),
    _RelaxItem(
      title: 'Peaceful Piano & Rain',
      subtitle: 'Lo-fi piano with soft background rain',
      icon: Icons.piano,
      videoId: '9bZkp7q19f0',
      category: 'Overthinking detox',
    ),
    _RelaxItem(
      title: 'Mind Clarity Meditation',
      subtitle: 'Clear your thoughts and find peace',
      icon: Icons.spa,
      videoId: 'dQw4w9WgXcQ',
      category: 'Overthinking detox',
    ),

    _RelaxItem(
      title: 'Morning Energy Boost',
      subtitle: 'Uplifting music to start your day',
      icon: Icons.wb_sunny,
      videoId: '9bZkp7q19f0',
      category: 'Motivation & energy',
    ),
    _RelaxItem(
      title: 'Power Through Your Day',
      subtitle: 'Motivational speech and energetic beats',
      icon: Icons.bolt,
      videoId: '3JZ_D3ELwOQ',
      category: 'Motivation & energy',
    ),
    _RelaxItem(
      title: 'Workout Motivation Mix',
      subtitle: 'High-energy tracks to keep you moving',
      icon: Icons.fitness_center,
      videoId: 'dQw4w9WgXcQ',
      category: 'Motivation & energy',
    ),

    _RelaxItem(
      title: 'Forest Birds & Wind',
      subtitle: 'Soft wind and forest ambience',
      icon: Icons.forest,
      videoId: 'dQw4w9WgXcQ',
      category: 'Stress & burnout',
    ),
    _RelaxItem(
      title: 'Stress Relief Meditation',
      subtitle: 'Release tension and restore balance',
      icon: Icons.self_improvement,
      videoId: '9bZkp7q19f0',
      category: 'Stress & burnout',
    ),
    _RelaxItem(
      title: 'Calm Piano for Work',
      subtitle: 'Gentle melodies to reduce workplace stress',
      icon: Icons.piano_outlined,
      videoId: '3JZ_D3ELwOQ',
      category: 'Stress & burnout',
    ),

    _RelaxItem(
      title: 'Positive Affirmations',
      subtitle: 'Build confidence with daily affirmations',
      icon: Icons.favorite,
      videoId: 'dQw4w9WgXcQ',
      category: 'Self-love & confidence',
    ),
    _RelaxItem(
      title: 'Surah Ar-Rahman',
      subtitle: 'Recitation by Mishary Al Afasy',
      icon: Icons.menu_book,
      videoId: 'dQw4w9WgXcQ',
      category: 'Self-love & confidence',
    ),
    _RelaxItem(
      title: 'Self-Care Meditation',
      subtitle: 'Love yourself and embrace inner peace',
      icon: Icons.spa_outlined,
      videoId: '9bZkp7q19f0',
      category: 'Self-love & confidence',
    ),
  ];

  List<_RelaxItem> get _filteredItems {
    if (_selectedCategory == 0) return _allItems;
    final categoryName = _categories[_selectedCategory];
    return _allItems.where((item) => item.category == categoryName).toList();
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialCategory != null) {
      final index = _categories.indexOf(widget.initialCategory!);
      if (index != -1) {
        _selectedCategory = index;
      }
    }
  }

  void _scrollToCategory(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_categoryScrollController.hasClients) return;

      if (index <= 1) {
        _categoryScrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return;
      }

      final itemWidth = 150.0;
      final spacing = 8.0;
      final targetPosition = ((itemWidth + spacing) * (index - 1));
      final maxScroll = _categoryScrollController.position.maxScrollExtent;
      final scrollTo = targetPosition > maxScroll ? maxScroll : targetPosition;

      _categoryScrollController.animateTo(
        scrollTo,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
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

  void _playVideo(_RelaxItem item) {
    VideoPlayerOverlay.show(
      context: context,
      videoId: item.videoId,
      title: item.title,
      subtitle: item.subtitle,
      icon: item.icon,
      onGenerateText: () async {
        return await RelaxationService.generateRelaxation(mood: 'calm');
      },
    );
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: const AppDrawer(),
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
                      backgroundImage: AssetImage('assets/avatar_placeholder1.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

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

                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    controller: _categoryScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
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

                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Listen or Watch:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    Text(
                      '${_filteredItems.length} videos',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

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
                              onPlay: () => _playVideo(item),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
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
}

class _RelaxItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String videoId;
  final String category;

  const _RelaxItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.videoId,
    required this.category,
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