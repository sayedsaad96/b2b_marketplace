import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/factory_entity.dart';
import '../../domain/usecases/get_factories_usecase.dart';
import '../../domain/usecases/get_factory_by_id_usecase.dart';
import '../../domain/usecases/get_top_factories_usecase.dart';
import 'factory_search_state.dart';

class FactorySearchCubit extends Cubit<FactorySearchState> {
  final GetFactoriesUseCase _getFactories;
  final GetFactoryByIdUseCase _getFactoryById;
  final GetTopFactoriesUseCase _getTopFactories;

  FactorySearchCubit({
    required GetFactoriesUseCase getFactories,
    required GetFactoryByIdUseCase getFactoryById,
    required GetTopFactoriesUseCase getTopFactories,
  }) : _getFactories = getFactories,
       _getFactoryById = getFactoryById,
       _getTopFactories = getTopFactories,
       super(FactorySearchInitial());

  int _currentPage = 0;
  static const int _pageSize = 20;

  // Current active filters
  String? _searchQuery;
  String? _category;

  Future<void> loadHomeData() async {
    emit(FactorySearchLoading());

    final topResult = await _getTopFactories();
    final searchResult = await _getFactories(page: 0, pageSize: _pageSize);

    topResult.fold(
      (failure) => emit(
        FactorySearchLoaded(
          topFactories: const [],
          searchResults: const [],
          hasReachedMax: false,
          error: failure.message,
        ),
      ),
      (topFactories) {
        searchResult.fold(
          (failure) => emit(
            FactorySearchLoaded(
              topFactories: topFactories,
              searchResults: const [],
              hasReachedMax: false,
              error: failure.message,
            ),
          ),
          (factories) {
            _currentPage = 1;
            emit(
              FactorySearchLoaded(
                topFactories: topFactories,
                searchResults: factories,
                hasReachedMax: factories.length < _pageSize,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> searchFactories({String? query, String? category}) async {
    _searchQuery = query ?? _searchQuery;
    _category = category ?? _category;
    _currentPage = 0;

    final currentState = state;
    List<Factory> currentTop = [];
    if (currentState is FactorySearchLoaded) {
      currentTop = currentState.topFactories;
    }

    emit(FactorySearchLoading());

    final result = await _getFactories(
      page: _currentPage,
      pageSize: _pageSize,
      searchQuery: _searchQuery,
      specialization: _category,
    );

    result.fold(
      (failure) => emit(
        FactorySearchLoaded(
          topFactories: currentTop,
          searchResults: const [],
          hasReachedMax: false,
          error: failure.message,
        ),
      ),
      (factories) {
        _currentPage = 1;
        emit(
          FactorySearchLoaded(
            topFactories: currentTop,
            searchResults: factories,
            hasReachedMax: factories.length < _pageSize,
          ),
        );
      },
    );
  }

  Future<void> fetchMoreFactories() async {
    if (state is! FactorySearchLoaded) return;
    final currentState = state as FactorySearchLoaded;
    if (currentState.hasReachedMax || currentState.error != null) return;

    final result = await _getFactories(
      page: _currentPage,
      pageSize: _pageSize,
      searchQuery: _searchQuery,
      specialization: _category,
    );

    result.fold(
      (failure) => emit(currentState.copyWith(error: failure.message)),
      (factories) {
        if (factories.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          _currentPage++;
          emit(
            FactorySearchLoaded(
              topFactories: currentState.topFactories,
              searchResults: currentState.searchResults + factories,
              hasReachedMax: factories.length < _pageSize,
            ),
          );
        }
      },
    );
  }

  Future<void> getFactoryDetails(String id) async {
    emit(FactoryProfileLoading());
    final result = await _getFactoryById(id);
    result.fold(
      (failure) => emit(FactoryProfileError(failure.message)),
      (factory) => emit(FactoryProfileLoaded(factory)),
    );
  }
}
