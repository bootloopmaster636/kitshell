import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'datetime_cubit.freezed.dart';
part 'datetime_state.dart';

@singleton
class DatetimeCubit extends Cubit<DatetimeState> {
  DatetimeCubit() : super(const DatetimeInitial());

  late Timer clock;

  void startTimer() {
    clock = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _updateTimer();
    });
  }

  void stopTimer() {
    clock.cancel();
  }

  void _updateTimer() {
    emit(DatetimeLoaded(DateTime.now()));
  }
}
