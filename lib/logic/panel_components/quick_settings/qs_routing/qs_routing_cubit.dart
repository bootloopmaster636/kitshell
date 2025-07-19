import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'qs_routing_cubit.freezed.dart';
part 'qs_routing_state.dart';

@singleton
class QsRoutingCubit extends Cubit<QsRoutingState> {
  QsRoutingCubit() : super(const QsRoutingState());

  void openDetailPage(Widget page) {
    emit(QsRoutingState(openedDetailPage: page));
  }

  void closeDetailPage() {
    emit(const QsRoutingState());
  }
}
