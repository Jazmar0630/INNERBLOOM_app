import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'pages/mood_tracker_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MentalHealthApp());
}

class MentalHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health Support',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Data Storage Service
class StorageService {
  static const String MOOD_KEY = 'mood_entries';
  static const String JOURNAL_KEY = 'journal_entries';

  // Save mood entries
  static Future<void> saveMoodEntries(List<MoodEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setString(MOOD_KEY, json.encode(jsonList));
  }

  // Load mood entries
  static Future<List<MoodEntry>> loadMoodEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(MOOD_KEY);
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => MoodEntry.fromJson(json)).toList();
  }

  // Save journal entries
  static Future<void> saveJournalEntries(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setString(JOURNAL_KEY, json.encode(jsonList));
  }

  // Load journal entries
  static Future<List<JournalEntry>> loadJournalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(JOURNAL_KEY);
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => JournalEntry.fromJson(json)).toList();
  }
}

// Main Home Page
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    MoodTrackerPage(),
    RelaxationPage(),
    JournalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Relax',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
        ],
      ),
    );
  }
}

// Dashboard Page
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: Text('Mental Health Support'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.teal[300]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello! 👋',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'How are you feeling today?',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
            ),
            SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildQuickActionCard(
                  context,
                  'Track Mood',
                  Icons.sentiment_satisfied_alt,
                  Colors.orange,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MoodTrackerPage())),
                ),
                _buildQuickActionCard(
                  context,
                  'Breathing Exercise',
                  Icons.air,
                  Colors.blue,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BreathingExercise())),
                ),
                _buildQuickActionCard(
                  context,
                  'Meditation',
                  Icons.self_improvement,
                  Colors.purple,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MeditationPage())),
                ),
                _buildQuickActionCard(
                  context,
                  'Journal',
                  Icons.edit_note,
                  Colors.green,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => JournalPage())),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Daily Tips
            Text(
              'Daily Wellness Tip',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.amber, size: 40),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'Take a 5-minute break every hour to stretch and breathe deeply.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title,
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.teal[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mood Entry Model
class MoodEntry {
  final String mood;
  final DateTime timestamp;

  MoodEntry({required this.mood, required this.timestamp});

  Map<String, dynamic> toJson() => {
    'mood': mood,
    'timestamp': timestamp.toIso8601String(),
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    mood: json['mood'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

// Relaxation Page
class RelaxationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: Text('Relaxation Exercises'),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            'Choose an Exercise',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal[900],
            ),
          ),
          SizedBox(height: 20),
          _buildExerciseCard(
            context,
            'Breathing Exercise',
            'Guided breathing to calm your mind',
            Icons.air,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BreathingExercise()),
            ),
          ),
          _buildExerciseCard(
            context,
            'Meditation Timer',
            'Timed meditation sessions',
            Icons.self_improvement,
            Colors.purple,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MeditationPage()),
            ),
          ),
          _buildExerciseCard(
            context,
            'Progressive Muscle Relaxation',
            'Release tension from your body',
            Icons.accessibility_new,
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MuscleRelaxationPage()),
            ),
          ),
          _buildExerciseCard(
            context,
            'Positive Affirmations',
            'Boost your mood with affirmations',
            Icons.favorite,
            Colors.pink,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AffirmationsPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, String title,
      String description, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// Breathing Exercise
class BreathingExercise extends StatefulWidget {
  @override
  _BreathingExerciseState createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends State<BreathingExercise>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _instruction = 'Press Start';
  bool _isRunning = false;
  Timer? _timer;
  int _phase = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _animation = Tween<double>(begin: 100, end: 200).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void _startExercise() {
    setState(() {
      _isRunning = true;
      _instruction = 'Breathe In';
      _phase = 0;
    });

    _controller.repeat(reverse: true);
    _startPhaseTimer();
  }

  void _startPhaseTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (!_isRunning) {
        timer.cancel();
        return;
      }

      setState(() {
        _phase = (_phase + 1) % 4;
        switch (_phase) {
          case 0:
            _instruction = 'Breathe In';
            break;
          case 1:
            _instruction = 'Hold';
            break;
          case 2:
            _instruction = 'Breathe Out';
            break;
          case 3:
            _instruction = 'Hold';
            break;
        }
      });
    });
  }

  void _stopExercise() {
    setState(() {
      _isRunning = false;
      _instruction = 'Press Start';
    });
    _controller.stop();
    _timer?.cancel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Breathing Exercise'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _instruction,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 50),
            Container(
              width: _animation.value,
              height: _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.blue[300]!, Colors.blue[700]!],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text(
              '4-4-4-4 Breathing Pattern',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _startExercise,
                  icon: Icon(Icons.play_arrow),
                  label: Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _isRunning ? _stopExercise : null,
                  icon: Icon(Icons.stop),
                  label: Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Meditation Page with Timer
class MeditationPage extends StatefulWidget {
  @override
  _MeditationPageState createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  final List<Map<String, dynamic>> meditations = [
    {
      'title': '5-Minute Calm',
      'duration': 5,
      'description': 'Quick meditation for busy days',
      'icon': Icons.speed,
      'color': Colors.purple,
    },
    {
      'title': 'Body Scan',
      'duration': 10,
      'description': 'Relax each part of your body',
      'icon': Icons.accessibility,
      'color': Colors.indigo,
    },
    {
      'title': 'Sleep Meditation',
      'duration': 15,
      'description': 'Prepare for restful sleep',
      'icon': Icons.bedtime,
      'color': Colors.deepPurple,
    },
    {
      'title': 'Mindfulness',
      'duration': 20,
      'description': 'Full mindfulness practice',
      'icon': Icons.self_improvement,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('Meditation'),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: meditations.length,
        itemBuilder: (context, index) {
          final meditation = meditations[index];
          return Container(
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: meditation['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  meditation['icon'],
                  color: meditation['color'],
                  size: 30,
                ),
              ),
              title: Text(
                meditation['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(meditation['description']),
                  SizedBox(height: 5),
                  Text(
                    '${meditation['duration']} minutes',
                    style: TextStyle(
                      color: meditation['color'],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              trailing: Icon(Icons.play_circle_filled,
                  color: meditation['color'], size: 40),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeditationTimerPage(
                      title: meditation['title'],
                      duration: meditation['duration'],
                      color: meditation['color'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Meditation Timer Page
class MeditationTimerPage extends StatefulWidget {
  final String title;
  final int duration;
  final Color color;

  MeditationTimerPage({
    required this.title,
    required this.duration,
    required this.color,
  });

  @override
  _MeditationTimerPageState createState() => _MeditationTimerPageState();
}

class _MeditationTimerPageState extends State<MeditationTimerPage> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration * 60;
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stopTimer();
          _showCompletionDialog();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
    });
    _timer?.cancel();
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _remainingSeconds = widget.duration * 60;
      _isRunning = false;
      _isPaused = false;
    });
    _timer?.cancel();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Meditation Complete! 🎉'),
        content: Text('Great job! You completed your meditation session.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Done'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: Text('Again'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - (_remainingSeconds / (widget.duration * 60));

    return Scaffold(
      backgroundColor: widget.color.withOpacity(0.1),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.color,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular Progress
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  ),
                ),
                Column(
                  children: [
                    Icon(Icons.self_improvement, size: 60, color: widget.color),
                    SizedBox(height: 20),
                    Text(
                      _formatTime(_remainingSeconds),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 60),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning && !_isPaused)
                  ElevatedButton.icon(
                    onPressed: _startTimer,
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                if (_isRunning)
                  ElevatedButton.icon(
                    onPressed: _pauseTimer,
                    icon: Icon(Icons.pause),
                    label: Text('Pause'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                if (_isPaused)
                  ElevatedButton.icon(
                    onPressed: _resumeTimer,
                    icon: Icon(Icons.play_arrow),
                    label: Text('Resume'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                SizedBox(width: 15),
                if (_isRunning || _isPaused)
                  ElevatedButton.icon(
                    onPressed: _resetTimer,
                    icon: Icon(Icons.replay),
                    label: Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Find a comfortable position and breathe naturally',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Muscle Relaxation Page
class MuscleRelaxationPage extends StatelessWidget {
  final List<String> steps = [
    'Find a comfortable position',
    'Take 3 deep breaths',
    'Tense your fists for 5 seconds, then relax',
    'Tense your arms for 5 seconds, then relax',
    'Raise your shoulders to your ears, hold, then relax',
    'Tense your face muscles, hold, then relax',
    'Tighten your stomach muscles, hold, then relax',
    'Tense your legs for 5 seconds, then relax',
    'Curl your toes, hold, then relax',
    'Take 3 more deep breaths and notice how relaxed you feel',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('Progressive Muscle Relaxation'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    steps[index],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Affirmations Page
class AffirmationsPage extends StatefulWidget {
  @override
  _AffirmationsPageState createState() => _AffirmationsPageState();
}

class _AffirmationsPageState extends State<AffirmationsPage> {
  final List<String> affirmations = [
    'I am worthy of love and respect',
    'I choose to be happy and positive',
    'I am capable of achieving my goals',
    'I trust in my abilities',
    'Every day is a fresh start',
    'I am stronger than my challenges',
    'I deserve peace and joy',
    'I am enough just as I am',
    'I choose to let go of worry',
    'I am grateful for this moment',
  ];

  int currentIndex = 0;

  void _nextAffirmation() {
    setState(() {
      currentIndex = (currentIndex + 1) % affirmations.length;
    });
  }

  void _previousAffirmation() {
    setState(() {
      currentIndex =
          (currentIndex - 1 + affirmations.length) % affirmations.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text('Positive Affirmations'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, size: 80, color: Colors.pink),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Text(
                  affirmations[currentIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.pink[900],
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _previousAffirmation,
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 30,
                    color: Colors.pink,
                  ),
                  SizedBox(width: 40),
                  Text(
                    '${currentIndex + 1} / ${affirmations.length}',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 40),
                  IconButton(
                    onPressed: _nextAffirmation,
                    icon: Icon(Icons.arrow_forward_ios),
                    iconSize: 30,
                    color: Colors.pink,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Journal Entry Model
class JournalEntry {
  final String content;
  final DateTime timestamp;

  JournalEntry({required this.content, required this.timestamp});

  Map<String, dynamic> toJson() => {
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

// Journal Page
class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<JournalEntry> entries = [];
  final TextEditingController _controller = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
  }

  Future<void> _loadJournalEntries() async {
    final loadedEntries = await StorageService.loadJournalEntries();
    setState(() {
      entries = loadedEntries;
      isLoading = false;
    });
  }

  Future<void> _addEntry() async {
    if (_controller.text.trim().isEmpty) return;

    final newEntry = JournalEntry(
      content: _controller.text.trim(),
      timestamp: DateTime.now(),
    );

    setState(() {
      entries.insert(0, newEntry);
      _controller.clear();
    });

    await StorageService.saveJournalEntries(entries);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Journal entry saved!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Journal Entry'),
        content: TextField(
          controller: _controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Write your thoughts...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addEntry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('My Journal'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book, size: 80, color: Colors.grey),
                      SizedBox(height: 20),
                      Text(
                        'No journal entries yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tap the + button to start writing',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.edit_note, color: Colors.green),
                              SizedBox(width: 10),
                              Text(
                                _formatDateTime(entry.timestamp),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            entry.content,
                            style: TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEntryDialog,
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} at ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}