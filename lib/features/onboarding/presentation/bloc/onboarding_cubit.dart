import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_state.dart';

/// Cubit managing onboarding page navigation.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  static const int totalPages = 3;

  void setPage(int index) {
    emit(state.copyWith(currentPage: index));
  }

  void nextPage() {
    if (state.currentPage < totalPages - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  bool get isLastPage => state.currentPage == totalPages - 1;
}
