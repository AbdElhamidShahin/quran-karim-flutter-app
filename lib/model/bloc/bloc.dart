import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/model/bloc/states.dart';
import '../PrayerTime.dart';
import '../api/apiServise.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final PrayerService prayerService;
  final Connectivity connectivity;

  PrayerBloc(this.prayerService, this.connectivity) : super(PrayerInitial()) {
    on<FetchPrayerTimes>(_onFetchPrayerTimes);
  }

  Future<void> _onFetchPrayerTimes(
    FetchPrayerTimes event,
    Emitter<PrayerState> emit,
  ) async {
    emit(PrayerLoadingState());

    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(PrayerErrorState('لا يوجد اتصال بالإنترنت'));
      return;
    }

    try {
      final timings =
          await prayerService.fetchPrayerTimesIfNeeded(event.lat, event.lng);
      emit(PrayerLoadedState(timings));
    } catch (e) {
      emit(PrayerErrorState("حدث خطأ أثناء جلب البيانات"));
    }
  }
}
