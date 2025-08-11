import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق القرآن',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SurahListScreen(),
    );
  }
}

class Surah {
  final String name;
  final String audioUrl;
  final String tafsir;

  Surah(this.name, this.audioUrl, this.tafsir);
}

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({super.key});

  final List<Surah> surahs = const [
    Surah(
      "الفاتحة",
      "https://server6.mp3quran.net/maher/001.mp3",
      "بسم الله الرحمن الرحيم: افتتاح للقرآن ودعاء لله بالهداية.",
    ),
    Surah(
      "البقرة",
      "https://server6.mp3quran.net/maher/002.mp3",
      "تفسير مختصر: سورة مدنية تعالج التشريع والعبادة والهداية.",
    ),
    Surah(
      "الإخلاص",
      "https://server6.mp3quran.net/maher/112.mp3",
      "تفسير مختصر: توحيد الله وتنزيهه عن الشريك.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سور القرآن')),
      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];
          return ListTile(
            title: Text(surah.name),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SurahDetailScreen(surah: surah),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  Future<void> toggleAudio() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      await _player.play(UrlSource(widget.surah.audioUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.surah.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("التفسير:", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(widget.surah.tafsir),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: toggleAudio,
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(isPlaying ? "إيقاف الصوت" : "تشغيل الصوت"),
            ),
          ],
        ),
      ),
    );
  }
}
