import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../mood/mood_appreciation.dart';
import '../model/mood_survey_data.dart';
import '../../services/mood_result_service.dart';
import '../widgets/video_player_overlay.dart'; // ADD THIS IMPORT

class MoodResultPage extends StatefulWidget {
  final MoodSurveyData data;

  const MoodResultPage({super.key, required this.data});

  @override
  State<MoodResultPage> createState() => _MoodResultPageState();
}

class _MoodResultPageState extends State<MoodResultPage> {
  int _selectedItemIndex = 0;

  final List<_RelaxItem> _items = const [
    _RelaxItem(
      title: 'Ocean waves',
      subtitle: 'Gentle rolling ocean and wave sounds',
      icon: Icons.waves,
      videoId: 'cB_CwY9dhrA',
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
      videoId: 'H4N5eFbLl9A',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _saveMoodToFirestore();
  }

  Future<void> _saveMoodToFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Calculate mood with proper scoring for each question
    final adjustedScore = _calculateAdjustedScore();
    final moodValue = ((adjustedScore / 4) * 5).round().clamp(1, 5);
    
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('moods')
          .add({
        'mood': moodValue,
        'avgScore': _avgScore,
        'adjustedScore': adjustedScore,
        'totalScore': _totalScore,
        'detectedMood': _detectedMoodLabel(),
        'createdAt': FieldValue.serverTimestamp(),
        'createdAtLocal': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      debugPrint('Failed to save mood: $e');
    }
  }

  double _calculateAdjustedScore() {
    final d = widget.data;
    
    // Page 1 questions:
    final stressScore = 4 - d.q1;      // Lower stress = better (invert)
    final sleepScore = d.q2;           // Higher sleep quality = better (keep)
    final focusScore = d.q3;           // Higher focus = better (keep)
    
    // Page 2 questions (all negative - lower = better):
    final overwhelmedScore = 4 - d.q4; // Lower overwhelmed = better (invert)
    final sleepIssuesScore = 4 - d.q5; // Lower sleep issues = better (invert)
    final distractionScore = 4 - d.q6; // Lower distraction = better (invert)
    
    return (stressScore + sleepScore + focusScore + overwhelmedScore + sleepIssuesScore + distractionScore) / 6;
  }

  double get _totalScore {
    final d = widget.data;
    return d.q1 + d.q2 + d.q3 + d.q4 + d.q5 + d.q6;
  }

  double get _avgScore => _totalScore / 6;

  String get _headline {
    final a = _avgScore;
    if (a >= 3.0) return "You've been under a lot of pressure lately.";
    if (a >= 2.0) return "You might be feeling a bit stressed or tired.";
    return "You seem fairly okay today — keep it up.";
  }

  String get _subtext {
    final a = _avgScore;
    if (a >= 3.0) {
      return "Try something gentle and calming. Small steps count, and you don't need to handle everything at once.";
    }
    if (a >= 2.0) {
      return "A short reset can help. Try breathing slowly, get some water, and take a quick break.";
    }
    return "Still, it's good to do a short relaxation to stay balanced and focused.";
  }

  String _detectedMoodLabel() {
    final a = _avgScore;
    if (a >= 3.0) return "overwhelmed";
    if (a >= 2.0) return "stressed";
    if (a >= 1.2) return "tired";
    return "calm";
  }

  Widget _buildSurveySummaryCard() {
    final d = widget.data;

    Widget row(String label, double value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${value.toStringAsFixed(0)} / 4',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Survey Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          row('Stress Level', d.q1),
          row('Sleep Quality', d.q2),
          row('Focus Level', d.q3),
          const SizedBox(height: 8),
          Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
          const SizedBox(height: 8),
          row('Overwhelmed', d.q4),
          row('Sleep Issues', d.q5),
          row('Distraction', d.q6),
        ],
      ),
    );
  }

  void _playVideo(int index, String videoId) {
    setState(() {
      _selectedItemIndex = index;
    });

    final moodLabel = _detectedMoodLabel();
    final selectedTitle = _items[index].title;

    VideoPlayerOverlay.show(
      context: context,
      videoId: videoId,
      title: _items[index].title,
      subtitle: _items[index].subtitle,
      icon: _items[index].icon,
      onGenerateText: () async {
        final moodPayload = '$moodLabel | content: $selectedTitle';
        return await MoodResultService.getSuggestion(mood: moodPayload);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3C5C5A), Color(0xFF9DA5A9)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Result header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'YOUR RESULTS',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _headline,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _subtext,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Mood: ${_detectedMoodLabel()}  •  Score: ${_avgScore.toStringAsFixed(1)} / 4",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                _buildSurveySummaryCard(),

                const Text(
                  "Recommended for you",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Choose content to help you feel better",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF3C5C5A),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MoodAppreciationPage()),
          );
        },
        icon: const Icon(Icons.favorite),
        label: const Text('CONTINUE', style: TextStyle(fontWeight: FontWeight.w600)),
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

class _RelaxCard extends StatefulWidget {
  final _RelaxItem item;
  final VoidCallback onPlay;

  const _RelaxCard({
    required this.item,
    required this.onPlay,
  });

  @override
  State<_RelaxCard> createState() => _RelaxCardState();
}

class _RelaxCardState extends State<_RelaxCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPlay,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white : Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.1),
                blurRadius: _isHovered ? 12 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF3C5C5A).withOpacity(_isHovered ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.item.icon, 
                  color: _isHovered ? const Color(0xFF2A4A47) : const Color(0xFF3C5C5A), 
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: _isHovered ? Colors.black : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: _isHovered ? Colors.black87 : Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isHovered ? const Color(0xFF2A4A47) : const Color(0xFF3C5C5A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}