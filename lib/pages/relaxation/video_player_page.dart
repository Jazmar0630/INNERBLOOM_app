import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  // ✅ Put your YouTube video ID here (NOT the full link)
  // Example: https://www.youtube.com/watch?v=dQw4w9WgXcQ  ->  dQw4w9WgXcQ
  static const String _videoId = 'dQw4w9WgXcQ';

  late final YoutubePlayerController _controller;

  Timer? _ticker;
  double _posSec = 0;
  double _durSec = 1;
  bool _isPlaying = false;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController.fromVideoId(
      videoId: _videoId,
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

    // Listen state changes (play/pause etc.)
    _controller.listen((value) {
      if (!mounted) return;
      setState(() {
        _isPlaying = value.playerState == PlayerState.playing;
      });
    });

    // Poll position/duration safely (works well on web)
    _ticker = Timer.periodic(const Duration(milliseconds: 300), (_) async {
      if (!mounted) return;
      try {
        final pos = await _controller.currentTime;
        final dur = await _controller.duration;

        setState(() {
          _posSec = (pos ?? 0).toDouble();
          _durSec = ((dur ?? 1).toDouble()).clamp(1, double.infinity);
          _isReady = true;
        });
      } catch (_) {
        // ignore temporary iframe timing issues
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _controller.close();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!_isReady) return;
    if (_isPlaying) {
      _controller.pauseVideo();
    } else {
      _controller.playVideo();
    }
  }

  void _seekRelative(int seconds) {
    if (!_isReady) return;
    final next = (_posSec + seconds).clamp(0, _durSec);
    _controller.seekTo(seconds: next.toDouble(), allowSeekAhead: true);
  }

  String _formatSeconds(double sec) {
    final s = sec.isFinite ? sec.round() : 0;
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  @override
  Widget build(BuildContext context) {
    final sliderValue = _posSec.clamp(0, _durSec);

    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 12),

                    // ✅ Player Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF3C5C5A),
                            width: 2,
                          ),
                        ),
                        child: player,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Relaxation Video',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ✅ Progress Slider (safe)
                    Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.white.withOpacity(0.3),
                          ),
                          child: Slider(
                            value: sliderValue,
                            min: 0,
                            max: _durSec,
                            onChanged: !_isReady
                                ? null
                                : (v) {
                                    setState(() => _posSec = v);
                                    _controller.seekTo(
                                      seconds: v,
                                      allowSeekAhead: true,
                                    );
                                  },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatSeconds(_posSec),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              _formatSeconds(_durSec),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ✅ Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.replay_10, color: Colors.white),
                          onPressed: !_isReady ? null : () => _seekRelative(-10),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            iconSize: 36,
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: const Color(0xFF3C5C5A),
                            ),
                            onPressed: _togglePlayPause,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.forward_10, color: Colors.white),
                          onPressed: !_isReady ? null : () => _seekRelative(10),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Enjoy this relaxing video. Take your time and let yourself unwind with this soothing content.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
