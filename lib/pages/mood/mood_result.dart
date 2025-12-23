import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../mood/mood_appreciation.dart';
import '../model/mood_survey_data.dart';
import '../../services/mood_result_service.dart';

class MoodResultPage extends StatefulWidget {
  final MoodSurveyData data;

  const MoodResultPage({super.key, required this.data});

  @override
  State<MoodResultPage> createState() => _MoodResultPageState();
}

class _MoodResultPageState extends State<MoodResultPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _overlayController;
  late Animation<Offset> _overlayOffset;

  bool _isOverlayVisible = false;

  // ✅ iframe controller
  YoutubePlayerController? _overlayYoutubeController;

  // ✅ Polling state (safe for web)
  Timer? _ticker;
  bool _isPlayerReady = false;
  bool _isPlaying = false;
  double _posSec = 0;
  double _durSec = 1;

  int _selectedItemIndex = 0;
  double _dragOffset = 0;

  // ✅ Backend response state
  bool _isLoadingText = false;
  String _backendText = '';

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

  // -----------------------
  // Simple scoring from q1..q6
  // -----------------------
  double get _totalScore {
    final d = widget.data;
    return d.q1 + d.q2 + d.q3 + d.q4 + d.q5 + d.q6;
  }

  double get _avgScore => _totalScore / 6;

  String get _headline {
    final a = _avgScore;
    if (a >= 3.0) return "You’ve been under a lot of pressure lately.";
    if (a >= 2.0) return "You might be feeling a bit stressed or tired.";
    return "You seem fairly okay today — keep it up.";
  }

  String get _subtext {
    final a = _avgScore;
    if (a >= 3.0) {
      return "Try something gentle and calming. Small steps count, and you don’t need to handle everything at once.";
    }
    if (a >= 2.0) {
      return "A short reset can help. Try breathing slowly, get some water, and take a quick break.";
    }
    return "Still, it’s good to do a short relaxation to stay balanced and focused.";
  }

  // ✅ Detect a mood label from survey
  String _detectedMoodLabel() {
    final a = _avgScore;
    if (a >= 3.0) return "overwhelmed";
    if (a >= 2.0) return "stressed";
    if (a >= 1.2) return "tired";
    return "calm";
  }

  // ✅ Call backend to generate suggestion text
  Future<void> _fetchBackendTextForCurrentMood() async {
    final moodLabel = _detectedMoodLabel();
    final selectedTitle = _items[_selectedItemIndex].title;
    final moodPayload = '$moodLabel | content: $selectedTitle';

    setState(() {
      _isLoadingText = true;
      _backendText = '';
    });

    try {
      final text = await MoodResultService.getSuggestion(mood: moodPayload);
      if (!mounted) return;
      setState(() {
        _backendText = text;
        _isLoadingText = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _backendText = 'Error: $e';
        _isLoadingText = false;
      });
    }
  }

  Widget _buildSurveySummaryCard() {
    final d = widget.data;

    Widget row(String label, double value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text('${value.toStringAsFixed(0)} / 4',
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Survey Summary',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          row('Stress (Q1)', d.q1),
          row('Mood (Q2)', d.q2),
          row('Energy (Q3)', d.q3),
          const Divider(),
          row('Overwhelmed (Q4)', d.q4),
          row('Sleep Issues (Q5)', d.q5),
          row('Focus Difficulty (Q6)', d.q6),
        ],
      ),
    );
  }

  Widget _buildBackendSuggestionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _isLoadingText
            ? const Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Expanded(child: Text("Generating suggestion...")),
                ],
              )
            : Text(
                _backendText.isEmpty
                    ? "Your mood-based suggestion will appear here."
                    : _backendText,
                style: const TextStyle(fontSize: 13, height: 1.35),
              ),
      ),
    );
  }

  // -----------------------
  // Video overlay controls (iframe)
  // -----------------------
  void _playVideo(int index, String videoId) {
    // cleanup previous
    _ticker?.cancel();
    _overlayYoutubeController?.close();
    _overlayYoutubeController = null;

    setState(() {
      _selectedItemIndex = index;
      _isOverlayVisible = true;
      _backendText = '';
      _isLoadingText = false;
      _isPlayerReady = false;
      _isPlaying = false;
      _posSec = 0;
      _durSec = 1;
    });

    final c = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
        playsInline: true,
        enableJavaScript: true,
        mute: false,
      ),
    );

    c.listen((value) {
      if (!mounted) return;
      setState(() {
        _isPlaying = value.playerState == PlayerState.playing;
      });
    });

    _overlayYoutubeController = c;

    _overlayController.forward();

    // poll time + duration (safe)
    _ticker = Timer.periodic(const Duration(milliseconds: 300), (_) async {
      if (!mounted) return;
      try {
        final pos = await c.currentTime;
        final dur = await c.duration;
        setState(() {
          _posSec = (pos ?? 0).toDouble();
          _durSec = ((dur ?? 1).toDouble()).clamp(1, double.infinity);
          _isPlayerReady = true;
        });
      } catch (_) {}
    });

    // ✅ Fetch backend response whenever user taps an item
    _fetchBackendTextForCurrentMood();
  }

  void _hideOverlay() {
    _overlayController.reverse().then((_) {
      if (!mounted) return;
      setState(() {
        _isOverlayVisible = false;
        _dragOffset = 0;
      });
      _ticker?.cancel();
      _ticker = null;

      _overlayYoutubeController?.pauseVideo();
      _overlayYoutubeController?.close();
      _overlayYoutubeController = null;
    });
  }

  void _toggleOverlayPlayPause() {
    if (!_isPlayerReady || _overlayYoutubeController == null) return;
    if (_isPlaying) {
      _overlayYoutubeController!.pauseVideo();
    } else {
      _overlayYoutubeController!.playVideo();
    }
  }

  void _seekOverlayRelative(int seconds) {
    if (!_isPlayerReady || _overlayYoutubeController == null) return;
    final next = (_posSec + seconds).clamp(0, _durSec);
    _overlayYoutubeController!.seekTo(seconds: next.toDouble(), allowSeekAhead: true);
  }

  String _formatSeconds(double sec) {
    final s = sec.isFinite ? sec.round() : 0;
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _overlayYoutubeController?.close();
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _buildMainContent(),
          if (_isOverlayVisible) _buildOverlay(),
        ],
      ),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.menu, color: Colors.white),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                _headline,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _subtext,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Detected mood: ${_detectedMoodLabel()}  •  Avg: ${_avgScore.toStringAsFixed(1)} / 4",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),

              _buildSurveySummaryCard(),

              const Text(
                "Choose one (each opens a default video):",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.separated(
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
    );
  }

  Widget _buildOverlay() {
    final controller = _overlayYoutubeController;
    final sliderValue = _posSec.clamp(0, _durSec);

    return Positioned.fill(
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

                          // ✅ Video player (iframe)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                height: 240,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFF3C5C5A),
                                    width: 2,
                                  ),
                                ),
                                child: controller == null
                                    ? const Center(child: CircularProgressIndicator())
                                    : YoutubePlayerScaffold(
                                        controller: controller,
                                        builder: (context, player) => player,
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          _buildBackendSuggestionCard(),

                          const SizedBox(height: 18),

                          // Title + subtitle
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _items[_selectedItemIndex].subtitle,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ✅ Seek bar (using polled pos/dur)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Slider(
                                  value: sliderValue,
                                  min: 0,
                                  max: _durSec,
                                  onChanged: !_isPlayerReady
                                      ? null
                                      : (value) {
                                          setState(() => _posSec = value);
                                          controller?.seekTo(
                                            seconds: value,
                                            allowSeekAhead: true,
                                          );
                                        },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatSeconds(_posSec),
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                    Text(
                                      _formatSeconds(_durSec),
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
                                onPressed: !_isPlayerReady ? null : () => _seekOverlayRelative(-10),
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
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  onPressed: _toggleOverlayPlayPause,
                                ),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                iconSize: 40,
                                icon: const Icon(Icons.forward_10, color: Color(0xFF7A9BA3)),
                                onPressed: !_isPlayerReady ? null : () => _seekOverlayRelative(10),
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
  final VoidCallback onPlay;

  const _RelaxCard({
    required this.item,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlay,
      child: Container(
        width: double.infinity,
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
      ),
    );
  }
}
