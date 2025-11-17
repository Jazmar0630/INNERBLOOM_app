import 'package:flutter/material.dart';
import 'home_page.dart';
import 'onboarding_intro_page.dart';
import 'user_page.dart';

class RelaxationPage extends StatefulWidget {
  const RelaxationPage({super.key});

  @override
  State<RelaxationPage> createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage> {
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
      icon: Icons.waves, // if this errors, replace with Icons.waves
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

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    setState(() => _navIndex = index);

    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1: // Figure it out / onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingIntroPage()),
        );
        break;
      case 2:
        // already here
        break;
      case 3: // User
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserPage()),
        );
        break;
    }
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
                  'Categories',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                // horizontal category chips
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final bool isSelected = index == _selectedCategory;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected
                                  ? const Color(0xFF3C5C5A)
                                  : Colors.white,
                            ),
                          ),
                        ),
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

                // horizontal scrolling cards
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
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

      // bottom nav
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _navIndex,
        onTap: _onNavTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        backgroundColor: const Color(0xFF3C5C5A),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.psychology_alt_outlined), label: 'Figure it out'),
          BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement), label: 'Relax'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF3C5C5A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow,
                size: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
