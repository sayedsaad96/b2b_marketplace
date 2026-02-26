# Task List Template

> **Constitution Reference**: All tasks must align with [constitution.md](../constitution.md).

## Feature: [Feature Name]

### Phase 1: Domain Layer
_No external dependencies — pure Dart only._

- [ ] Create entity classes in `domain/entities/`
- [ ] Define repository contracts in `domain/repositories/`
- [ ] Implement use cases in `domain/usecases/`

### Phase 2: Data Layer
_Implements domain contracts with Supabase._

- [ ] Create data models in `data/models/` (fromJson/toJson)
- [ ] Implement remote data sources in `data/datasources/`
- [ ] Implement repositories in `data/repositories/`
- [ ] Set up Supabase tables, RLS policies, indexes

### Phase 3: Presentation Layer
_UI + State management._

- [ ] Create Bloc/Cubit classes in `presentation/bloc/`
- [ ] Build page widgets in `presentation/pages/`
- [ ] Build reusable widgets in `presentation/widgets/`
- [ ] Add routes to `go_router` configuration
- [ ] Add role-based guards if needed

### Phase 4: Integration
_Wiring everything together._

- [ ] Register dependencies in `get_it` (`injection_container.dart`)
- [ ] Add localization keys (AR + EN) in `assets/translations/`
- [ ] Apply `flutter_screenutil` to all new UI
- [ ] Ensure RTL layout correctness

### Phase 5: Testing
_Per constitution testing requirements._

- [ ] Unit tests for use cases
- [ ] Unit tests for repositories
- [ ] Bloc/Cubit tests
- [ ] Widget tests for key screens

### Phase 6: Polish
- [ ] Run `flutter analyze` — zero warnings
- [ ] Run `dart format .` — all files formatted
- [ ] Code review & PR
