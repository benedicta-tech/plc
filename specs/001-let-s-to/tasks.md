# Tasks: Preachers Management

**Input**: Design documents from `/specs/001-let-s-to/`
**Prerequisites**: plan.md (required), research.md, data-model.md

## Phase 3.1: Setup
- [X] T001 [P] Create project structure for the feature in `lib/features/preachers` and `test/features/preachers`.
- [X] T002 [P] Add dependencies to `pubspec.yaml`: `flutter_bloc`, `dio`, `get_it`, `floor`, `mockito`.

## Phase 3.2: Data Layer
- [X] T003 [P] Create `PreacherModel` and `PreachingThemeModel` in `lib/features/preachers/data/models/`.
- [X] T004 [P] Create `PreacherDao` and `PreachingThemeDao` in `lib/features/preachers/data/datasources/local/`.
- [X] T005 [P] Create `AppDatabase` in `lib/core/config/`.
- [X] T006 [P] Create `PreacherRemoteDataSource` in `lib/features/preachers/data/datasources/remote/`.
- [X] T007 [P] Create `PreacherRepositoryImpl` in `lib/features/preachers/data/repositories/`.

## Phase 3.3: Domain Layer
- [X] T008 [P] Create `Preacher` and `PreachingTheme` entities in `lib/features/preachers/domain/entities/`.
- [X] T009 [P] Create `PreacherRepository` abstract class in `lib/features/preachers/domain/repositories/`.
- [X] T010 [P] Create `GetPreachers` use case in `lib/features/preachers/domain/usecases/`.
- [X] T011 [P] Create `GetPreacherById` use case in `lib/features/preachers/domain/usecases/`.

## Phase 3.4: Presentation Layer
- [X] T012 [P] Create `PreachersBloc` in `lib/features/preachers/presentation/bloc/`.
- [X] T013 [P] Create `PreacherProfileBloc` in `lib/features/preachers/presentation/bloc/`.
- [X] T014 [P] Create `PreachersListPage` in `lib/features/preachers/presentation/pages/`.
- [X] T015 [P] Create `PreacherProfilePage` in `lib/features/preachers/presentation/pages/`.

## Phase 3.5: Testing
- [X] T016 [P] Write unit tests for `GetPreachers` and `GetPreacherById` use cases in `test/features/preachers/domain/usecases/`.
- [X] T017 [P] Write unit tests for `PreachersBloc` and `PreacherProfileBloc` in `test/features/preachers/presentation/bloc/`.
- [X] T018 [P] Write widget tests for `PreachersListPage` and `PreacherProfilePage` in `test/features/preachers/presentation/pages/`.

## Phase 3.6: Integration
- [X] T019 [P] Configure dependency injection for the feature in `lib/core/di/`.
- [X] T020 [P] Implement navigation between `PreachersListPage` and `PreacherProfilePage`.