import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../model/PrayerTime.dart';
import '../../model/api/apiServise.dart';
import '../../model/bloc/bloc.dart';
import '../../model/bloc/states.dart';
import '../../veiw_model/helper/Position/getPosition.dart';
import '../wedgit/CustomAppBar.dart';
import '../wedgit/buildLoadingShimmer.dart';
import '../wedgit/buildPrayerTimesUI.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late final PrayerService _prayerService;
  String nextPrayerName = '';
  Duration remainingTime = Duration.zero;
  Timer? _timer;
  Map<String, String> _prayerTimes = {};
  bool _isAdhanPlaying = false;
  late AudioPlayer _audioPlayer;
  Set<String> _playedPrayers = {}; // عشان مانشغلش الأذان مرتين لنفس الصلاة

  @override
  void initState() {
    super.initState();
    _prayerService = PrayerService();
    _audioPlayer = AudioPlayer();
    fetchData();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final position = await getPosition();
      context.read<PrayerBloc>().add(
        FetchPrayerTimes(lat: position.latitude, lng: position.longitude),
      );
    } catch (e) {
      context.read<PrayerBloc>().add(
        FetchPrayerTimes(lat: 30.0444, lng: 31.2357),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void startPrayerTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_prayerTimes.isNotEmpty) {
        _calculateNextPrayerTimes();
        _checkAndPlayAdhan();
      }
    });
  }

  void _calculateNextPrayerTimes() {
    final now = DateTime.now();
    DateTime? nextPrayerDateTime;
    String nextPrayer = '';

    final prayersInOrder = [
      {'name': 'الفجر', 'time': _prayerTimes['الفجر']},
      {'name': 'الظهر', 'time': _prayerTimes['الظهر']},
      {'name': 'العصر', 'time': _prayerTimes['العصر']},
      {'name': 'المغرب', 'time': _prayerTimes['المغرب']},
      {'name': 'العشاء', 'time': _prayerTimes['العشاء']},
    ];

    for (final prayer in prayersInOrder) {
      final timeStr = prayer['time'];
      if (timeStr == null) continue;

      final timeParts = timeStr.split(':');
      if (timeParts.length != 2) continue;

      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) continue;

      var prayerDateTime = DateTime(now.year, now.month, now.day, hour, minute);

      if (prayerDateTime.isBefore(now)) {
        if (prayer['name'] == 'العشاء') {
          final fajrTime = prayersInOrder[0]['time']?.split(':');
          if (fajrTime != null && fajrTime.length == 2) {
            prayerDateTime = DateTime(
              now.year,
              now.month,
              now.day + 1,
              int.parse(fajrTime[0]),
              int.parse(fajrTime[1]),
            );
            nextPrayer = prayersInOrder[0]['name']!;
            nextPrayerDateTime = prayerDateTime;
            break;
          }
        }
        continue;
      }

      if (nextPrayerDateTime == null || prayerDateTime.isBefore(nextPrayerDateTime)) {
        nextPrayerDateTime = prayerDateTime;
        nextPrayer = prayer['name']!;
      }
    }

    if (nextPrayerDateTime != null) {
      setState(() {
        nextPrayerName = nextPrayer;
        remainingTime = nextPrayerDateTime!.difference(now);
      });
    }
  }

  void _checkAndPlayAdhan() async {
    final now = DateTime.now();

    for (final entry in _prayerTimes.entries) {
      final timeParts = entry.value.split(':');
      if (timeParts.length != 2) continue;

      final prayerHour = int.tryParse(timeParts[0]);
      final prayerMinute = int.tryParse(timeParts[1]);
      if (prayerHour == null || prayerMinute == null) continue;

      final prayerTime = DateTime(now.year, now.month, now.day, prayerHour, prayerMinute);

      if (now.difference(prayerTime).inSeconds.abs() < 5 && !_playedPrayers.contains(entry.key)) {
        _playedPrayers.add(entry.key);
        await _prayerService.playAdhan(entry.key);
        debugPrint('🎶 تم تشغيل الأذان لصلاة ${entry.key}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'مواقيت الصلاة'),
      body: BlocBuilder<PrayerBloc, PrayerState>(
        builder: (context, state) {
          if (state is PrayerLoadingState) {
            return Center(child: buildLoadingShimmer());
          } else if (state is PrayerLoadedState) {
            if (_prayerTimes != state.times) {
              _prayerTimes = state.times;
              _playedPrayers.clear();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _calculateNextPrayerTimes();
                startPrayerTimer();
              });
            }
            return buildPrayerTimesUI(
              state.times,
              nextPrayerName,
              remainingTime,
              _isAdhanPlaying,
            );
          } else if (state is PrayerErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/Animation - 1745055052923.json',
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'لا يوجد اتصال بالإنترنت',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'يرجى التحقق من الشبكة والمحاولة مرة أخرى',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return Center(child: buildLoadingShimmer());
        },
      ),
    );
  }
}
