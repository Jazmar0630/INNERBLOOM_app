// lib/pages/relaxation/relaxation_page.dart
import 'package:flutter/material.dart';

import '../home/home_page.dart';
import '../mood/onboarding_intro_page.dart';
import '../user/user_page.dart';
import '../widgets/app_drawer.dart';
import '../widgets/video_player_overlay.dart';

class RelaxationPage extends StatefulWidget {
  const RelaxationPage({super.key, this.initialCategory});

  final String? initialCategory;

  @override
  State<RelaxationPage> createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage> {
  int _navIndex = 2;

  final List<String> _categories = const [
    'Anxiety reliefs',
    'Overthinking detox',
    'Self-love & confidence',
    'Stress & burnout',
  ];

  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? _categories.first;
  }

  void _playVideo({
    required String title,
    required String subtitle,
    required IconData icon,
    required String videoId,
  }) {
    VideoPlayerOverlay.show(
      context: context,
      videoId: videoId,
      title: title,
      subtitle: subtitle,
      icon: icon,
    );
  }

  void _onNavTap(int i) {
    setState(() => _navIndex = i);

    if (i == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (i == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingIntroPage()),
      );
    } else if (i == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const UserPage()),
      );
    }
  }

  List<_RelaxItem> _itemsFor(String category) {
    // You can replace these with your real content (video ids, text, etc.)
    switch (category) {
      case 'Anxiety reliefs':
        return const [
          _RelaxItem(
            title: 'Breathing reset',
            subtitle: 'Guided breathing to reduce anxiety fast',
            icon: Icons.air,
            videoId: 'inpok4MKVLM',
          ),
          _RelaxItem(
            title: 'Grounding technique',
            subtitle: 'Calm your body using 5-4-3-2-1 method',
            icon: Icons.spa,
            videoId: '30VMIEmA114',
          ),
        ];
      case 'Overthinking detox':
        return const [
          _RelaxItem(
            title: 'Quiet the mind',
            subtitle: 'Short talk to slow racing thoughts',
            icon: Icons.psychology_alt_outlined,
            videoId: '3JZ_D3ELwOQ',
          ),
          _RelaxItem(
            title: 'Focus music',
            subtitle: 'Soft background sound for studying',
            icon: Icons.headphones,
            videoId: 'jfKfPfyJRdk',
          ),
        ];
      case 'Self-love & confidence':
        return const [
          _RelaxItem(
            title: 'Self-love affirmations',
            subtitle: 'A gentle reminder that you’re doing your best',
            icon: Icons.favorite_outline,
            videoId: 'ZToicYcHIOU',
          ),
          _RelaxItem(
            title: 'Confidence boost',
            subtitle: 'Small mindset shift, big results',
            icon: Icons.emoji_events_outlined,
            videoId: 'wnHW6o8WMas',
          ),
        ];
      case 'Stress & burnout':
      default:
        return const [
          _RelaxItem(
            title: 'Stress release',
            subtitle: 'Relax shoulders + jaw + breathing',
            icon: Icons.self_improvement,
            videoId: 'aXItOY0sLRY',
          ),
          _RelaxItem(
            title: 'Sleep wind-down',
            subtitle: 'Slow down and reset after a long day',
            icon: Icons.nightlight_round,
            videoId: '2OEL4P1Rz04',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _itemsFor(_selectedCategory);

    return Scaffold(
      extendBody: true,
      drawer: const AppDrawer(),
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
      body: Container(
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
              // TOP BAR (hover menu)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => HoverMenuButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/avatar_placeholder1.png'),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                'Relaxation',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Pick a category and start calming down.',
                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
              ),

              const SizedBox(height: 16),

              // CATEGORY ROW (hover brighten)
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    final selected = cat == _selectedCategory;

                    return HoverPill(
                      selected: selected,
                      text: cat,
                      onTap: () => setState(() => _selectedCategory = cat),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // CONTENT CARDS (hover brighten)
              ...items.map((it) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: HoverBrightCard(
                    onTap: () => _playVideo(
                      title: it.title,
                      subtitle: it.subtitle,
                      icon: it.icon,
                      videoId: it.videoId,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(it.icon, size: 28, color: Colors.black87),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  it.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  it.subtitle,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () => _playVideo(
                                      title: it.title,
                                      subtitle: it.subtitle,
                                      icon: it.icon,
                                      videoId: it.videoId,
                                    ),
                                    icon: const Icon(Icons.play_arrow),
                                    label: const Text('Play'),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                      backgroundColor: Colors.black.withOpacity(0.06),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      foregroundColor: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
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

/// ✅ Hover menu button (brighter on hover)
class HoverMenuButton extends StatefulWidget {
  final VoidCallback onPressed;
  const HoverMenuButton({super.key, required this.onPressed});

  @override
  State<HoverMenuButton> createState() => _HoverMenuButtonState();
}

class _HoverMenuButtonState extends State<HoverMenuButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _hover ? Colors.white.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.25),
                    blurRadius: 12,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: IconButton(
          onPressed: widget.onPressed,
          splashRadius: 20,
          icon: Icon(
            Icons.menu,
            color: _hover ? Colors.white : Colors.white.withOpacity(0.85),
          ),
        ),
      ),
    );
  }
}

/// ✅ Hover-bright wrapper for cards
class HoverBrightCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const HoverBrightCard({super.key, required this.child, this.onTap});

  @override
  State<HoverBrightCard> createState() => _HoverBrightCardState();
}

class _HoverBrightCardState extends State<HoverBrightCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = _hover;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(active ? 1.01 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.20),
                    blurRadius: 16,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: widget.onTap,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: active ? 1.0 : 0.92,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// ✅ Hover category pill
class HoverPill extends StatefulWidget {
  final bool selected;
  final String text;
  final VoidCallback onTap;

  const HoverPill({
    super.key,
    required this.selected,
    required this.text,
    required this.onTap,
  });

  @override
  State<HoverPill> createState() => _HoverPillState();
}

class _HoverPillState extends State<HoverPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hover;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.white.withOpacity(0.22) : Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active ? Colors.white.withOpacity(0.60) : Colors.white.withOpacity(0.18),
              width: active ? 2.0 : 1.2,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.18),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
