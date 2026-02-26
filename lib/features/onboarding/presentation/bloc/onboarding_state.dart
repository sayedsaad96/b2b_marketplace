part of 'onboarding_cubit.dart';

/// State for onboarding page tracking.
class OnboardingState extends Equatable {
  const OnboardingState({this.currentPage = 0});

  final int currentPage;

  OnboardingState copyWith({int? currentPage}) {
    return OnboardingState(currentPage: currentPage ?? this.currentPage);
  }

  @override
  List<Object?> get props => [currentPage];
}
