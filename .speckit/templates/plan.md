# Implementation Plan Template

> **Constitution Reference**: All plans must align with [constitution.md](../constitution.md).

## Feature: [Feature Name]

### 1. Summary
_What is being built and why._

### 2. Architecture Impact
_How this feature fits into the Clean Architecture structure._

```
features/
└── <feature_name>/
    ├── data/
    │   ├── datasources/
    │   ├── models/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    └── presentation/
        ├── bloc/
        ├── pages/
        └── widgets/
```

### 3. Domain Layer
_Entities, repository contracts, use cases to create._

### 4. Data Layer
_Models, data source implementations, Supabase table design._

### 5. Presentation Layer
_Blocs/Cubits, pages, widgets._

### 6. Navigation
_New routes to add to `go_router` config. Role guards needed._

### 7. Localization
_New translation keys to add (AR + EN)._

### 8. Dependency Injection
_New registrations in `get_it` service locator._

### 9. Dependencies
_New packages (justified per constitution)._

### 10. Migration / Database
_Supabase migrations, RLS policies, indexes._

### 11. Risks & Open Questions
_Potential issues, unknowns, decisions to make._
