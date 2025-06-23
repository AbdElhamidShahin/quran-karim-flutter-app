import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../model/PrayerTime.dart';
import '../../model/api/NotificationService.dart';
import '../../model/bloc/bloc.dart';
import '../../model/bloc/states.dart';
import '../../veiw/wedgit/CustomAppBar.dart';
import '../../veiw/wedgit/buildLoadingShimmer.dart';
import '../../veiw/wedgit/buildPrayerTimesUI.dart';
import '../../veiw_model/helper/Position/getPosition.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({Key? key}) : super(key: key);

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  String nextPrayerName = '';
  Duration remainingTime = Duration.zero;
  Timer? _timer;
  Map<String, String> _prayerTimes = {};
  DateTime _lastPrayerUpdateDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchAndStart();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _fetchAndStart() {
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final position = await getPosition();
      context.read<PrayerBloc>().add(
        FetchPrayerTimes(lat: position.latitude, lng: position.longitude),
      );
    } catch (_) {
      context.read<PrayerBloc>().add(
        FetchPrayerTimes(lat: 30.0444, lng: 31.2357),
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();

      if (now.day != _lastPrayerUpdateDate.day ||
          now.month != _lastPrayerUpdateDate.month ||
          now.year != _lastPrayerUpdateDate.year) {
        _lastPrayerUpdateDate = now;
        _fetchData();
      }

      if (_prayerTimes.isNotEmpty) {
        _calculateNextPrayer();
      }
    });
  }

  void _calculateNextPrayer() {
    final now = DateTime.now();
    DateTime? nextTime;
    String nextName = '';

    _prayerTimes.forEach((name, time) {
      final parts = time.split(':');
      if (parts.length != 2) return;
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h == null || m == null) return;
      var t = DateTime(now.year, now.month, now.day, h, m);
      if (t.isBefore(now)) t = t.add(const Duration(days: 1));
      if (nextTime == null || t.isBefore(nextTime!)) {
        nextTime = t;
        nextName = name;
      }
    });

    if (nextTime != null) {
      setState(() {
        nextPrayerName = nextName;
        remainingTime = nextTime!.difference(now);
      });
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
          }
          if (state is PrayerLoadedState) {
            if (_prayerTimes != state.times) {
              _prayerTimes = state.times;
              WidgetsBinding.instance.addPostFrameCallback((_) {

                _calculateNextPrayer();
                _startTimer();
              });
            }
            return buildPrayerTimesUI(
              state.times,
              nextPrayerName,
              remainingTime,
              false,
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/Animation - 1745055052923.json',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 16),
                const Text(
                  'فشل في جلب البيانات، حاول لاحقًا',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
