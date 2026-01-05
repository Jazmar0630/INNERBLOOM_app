import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// Reusable Video Player Overlay Widget
/// 
/// Usage:
/// ```dart
/// VideoPlayerOverlay.show(
///   context: context,
///   videoId: 'dQw4w9WgXcQ',
///   title: 'Ocean Waves',
///   subtitle: 'Gentle rolling ocean and wave sounds',
///   icon: Icons.waves,
///   onGenerateText: () async {
///     // Optional: Call your API to generate text
///     return await YourService.generateText();
///   },
/// );
/// ```
class VideoPlayerOverlay extends StatefulWidget {
  final String videoId;
  final String title;
  final String subtitle;
  final IconData icon;
  final Future<String> Function()? onGenerateText;

  const VideoPlayerOverlay({
    super.key,
    required this.videoId,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onGenerateText,
  });

  /// Static method to show the overlay
  static Future<void> show({
    required BuildContext context,
    required String videoId,
    required String title,
    required String subtitle,
    required IconData icon,
    Future<String> Function()? onGenerateText,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black26,
        pageBuilder: (context, animation, secondaryAnimation) {
          return VideoPlayerOverlay(
            videoId: videoId,
            title: title,
            subtitle: subtitle,
            icon: icon,
            onGenerateText: onGenerateText,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  State<VideoPlayerOverlay> createState() => _VideoPlayerOverlayState();
}

class _VideoPlayerOverlayState extends State<VideoPlayerOverlay> {
  YoutubePlayerController? _controller;
  Timer? _ticker;
  
  bool _isPlayerReady = false;
  bool _isPlaying = false;
  double _posSec = 0;
  double _durSec = 1;
  double _dragOffset = 0;

  // Generated text state
  bool _isLoadingText = false;
  String _generatedText = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
        playsInline: true,
        enableJavaScript: true,
        mute: false,
         origin: 'https://www.youtube-nocookie.com',
      ),
    );

    _controller!.listen((value) {
      if (!mounted) return;
      setState(() {
        _isPlaying = value.playerState == PlayerState.playing;
      });
    });

    _ticker = Timer.periodic(const Duration(milliseconds: 300), (_) async {
      if (!mounted) return;
      try {
        final pos = await _controller!.currentTime;
        final dur = await _controller!.duration;
        setState(() {
          _posSec = (pos ?? 0).toDouble();
          _durSec = ((dur ?? 1).toDouble()).clamp(1, double.infinity);
          _isPlayerReady = true;
        });
      } catch (_) {}
    });
  }

  void _close() {
    Navigator.of(context).pop();
  }

  void _togglePlayPause() {
    if (!_isPlayerReady || _controller == null) return;
    if (_isPlaying) {
      _controller!.pauseVideo();
    } else {
      _controller!.playVideo();
    }
  }

  void _seekRelative(int seconds) {
    if (!_isPlayerReady || _controller == null) return;
    final next = (_posSec + seconds).clamp(0, _durSec);
    _controller!.seekTo(seconds: next.toDouble(), allowSeekAhead: true);
  }

  String _formatSeconds(double sec) {
    final s = sec.isFinite ? sec.round() : 0;
    final m = (s ~/ 60).toString();
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  Future<void> _generateText() async {
    if (widget.onGenerateText == null) return;
    
    setState(() {
      _isLoadingText = true;
      _generatedText = '';
    });

    try {
      final text = await widget.onGenerateText!();
      if (!mounted) return;
      setState(() {
        _generatedText = text;
        _isLoadingText = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _generatedText = 'Error: $e';
        _isLoadingText = false;
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _close,
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping inside
            onVerticalDragUpdate: (details) {
              setState(() => _dragOffset += details.delta.dy);
            },
            onVerticalDragEnd: (_) {
              if (_dragOffset > 100) {
                _close();
              } else {
                setState(() => _dragOffset = 0);
              }
            },
            child: Transform.translate(
              offset: Offset(0, _dragOffset.clamp(0, double.infinity)),
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
                      // Drag handle
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

                      // Video player - 16:9 aspect ratio
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AspectRatio(
                          aspectRatio: 16 / 9, // Standard HD video ratio
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
                              child: _controller == null
                                  ? const Center(child: CircularProgressIndicator())
                                  : YoutubePlayerScaffold(
                                      controller: _controller!,
                                      builder: (context, player) => player,
                                    ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Title and subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(widget.icon, size: 24, color: const Color(0xFF3C5C5A)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.subtitle,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Optional: Generate text button
                      if (widget.onGenerateText != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoadingText ? null : _generateText,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3C5C5A),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _isLoadingText
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Generate Relaxation Text',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Display generated text
                        if (_generatedText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3C5C5A).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF3C5C5A).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                _generatedText,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],

                      // NEW CONTROLS DESIGN
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // Progress bar
                            Stack(
                              children: [
                                // Background track
                                Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                // Active track
                                FractionallySizedBox(
                                  widthFactor: _durSec > 0 ? (_posSec / _durSec).clamp(0.0, 1.0) : 0,
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Time display
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatSeconds(_posSec),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _formatSeconds(_durSec),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Control buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Backward 10s button
                          IconButton(
                            iconSize: 50,
                            icon: Icon(
                              Icons.replay_10_rounded,
                              color: Colors.grey[600],
                            ),
                            onPressed: !_isPlayerReady ? null : () => _seekRelative(-10),
                          ),
                          
                          const SizedBox(width: 30),

                          // Play/Pause button
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF3C5C5A),
                            ),
                            child: IconButton(
                              iconSize: 42,
                              icon: Icon(
                                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                color: Colors.white,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                          ),

                          const SizedBox(width: 30),

                          // Forward 10s button
                          IconButton(
                            iconSize: 50,
                            icon: Icon(
                              Icons.forward_10_rounded,
                              color: Colors.grey[600],
                            ),
                            onPressed: !_isPlayerReady ? null : () => _seekRelative(10),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
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