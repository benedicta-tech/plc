# Generic Features Library - Usage Example

This library drastically reduces boilerplate when creating new read-only features that fetch data from Google Sheets and cache locally.

## Quick Start

Creating a new feature now requires only **4 steps**:

### 1. Define your Entity

```dart
// lib/features/parishes/domain/entities/parish.dart
class Parish {
  final String id;
  final String name;
  final String city;
  final String priest;

  Parish({
    required this.id,
    required this.name,
    required this.city,
    required this.priest,
  });
}
```

### 2. Define your Model (extends EntityModel)

```dart
// lib/features/parishes/data/models/parish_model.dart
import 'package:plc/core/features/core_features.dart';
import 'package:plc/features/parishes/domain/entities/parish.dart';

class ParishModel extends EntityModel<Parish> {
  @override
  final String id;
  final String name;
  final String city;
  final String priest;

  ParishModel({
    required this.id,
    required this.name,
    required this.city,
    required this.priest,
  });

  factory ParishModel.fromJson(Map<String, dynamic> json) {
    return ParishModel(
      id: json['id'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      priest: json['priest'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'priest': priest,
    };
  }

  @override
  Parish toEntity() {
    return Parish(
      id: id,
      name: name,
      city: city,
      priest: priest,
    );
  }
}
```

### 3. Setup Dependency Injection

```dart
// lib/core/di/injection_container.dart

// For Parishes feature
sl.registerLazySingleton<GenericRemoteDataSource<ParishModel>>(
  () => GenericGSheetsDataSource<ParishModel>(
    gsheetsService: sl(),
    sheetType: 'main',  // from sheets.json config
    worksheetName: 'Parishes',
    fromJson: ParishModel.fromJson,
    // Optional: add sorting
    sortList: (items) {
      items.sort((a, b) => a.name.compareTo(b.name));
      return items;
    },
  ),
);

sl.registerLazySingleton<GenericLocalDataSource<ParishModel>>(
  () => GenericLocalDataSourceImpl<ParishModel>(
    storageService: sl(),
    storageKey: 'parishes',
    syncDateKey: 'parishes_last_sync',
    fromJson: ParishModel.fromJson,
  ),
);

sl.registerLazySingleton<GenericRepository<Parish>>(
  () => GenericCachedRepository<Parish, ParishModel>(
    remoteDataSource: sl<GenericRemoteDataSource<ParishModel>>(),
    localDataSource: sl<GenericLocalDataSource<ParishModel>>(),
    cacheDurationInDays: 1,  // Optional: default is 1
  ),
);

sl.registerLazySingleton(() => GetAllUseCase<Parish>(sl()));

sl.registerFactory(
  () => GenericListBloc<Parish, void>(
    getAllUseCase: sl<GetAllUseCase<Parish>>(),
    // Optional: add search support
    searchPredicate: (parish, query) =>
        parish.name.toLowerCase().contains(query.toLowerCase()) ||
        parish.city.toLowerCase().contains(query.toLowerCase()),
  ),
);
```

### 4. Use in your UI

```dart
// lib/features/parishes/presentation/pages/parishes_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/core/features/core_features.dart';
import 'package:plc/features/parishes/domain/entities/parish.dart';

class ParishesListPage extends StatefulWidget {
  const ParishesListPage({super.key});

  @override
  State<ParishesListPage> createState() => _ParishesListPageState();
}

class _ParishesListPageState extends State<ParishesListPage> {
  @override
  void initState() {
    super.initState();
    context.read<GenericListBloc<Parish, void>>().add(LoadItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parishes')),
      body: BlocBuilder<GenericListBloc<Parish, void>, GenericListState<Parish>>(
        builder: (context, state) {
          if (state is ListLoading<Parish>) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ListLoaded<Parish, void>) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final parish = state.items[index];
                return ListTile(
                  title: Text(parish.name),
                  subtitle: Text(parish.city),
                );
              },
            );
          } else if (state is ListError<Parish>) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
```

## Advanced Features

### Search Support

Add search predicate when creating the BLoC:

```dart
GenericListBloc<Parish, void>(
  getAllUseCase: sl(),
  searchPredicate: (parish, query) =>
      parish.name.toLowerCase().contains(query.toLowerCase()),
)
```

Then trigger search:

```dart
context.read<GenericListBloc<Parish, void>>()
    .add(SearchItems(query: searchQuery));
```

### Filter Support

Define filter criteria type and add filter predicate:

```dart
GenericListBloc<Parish, List<String>>(
  getAllUseCase: sl(),
  filterPredicate: (parish, cities) =>
      cities.contains(parish.city),
)
```

Then trigger filter:

```dart
context.read<GenericListBloc<Parish, List<String>>>()
    .add(FilterItems(filterCriteria: ['São Paulo', 'Rio de Janeiro']));
```

### Custom Filtering in Data Source

Add filtering or sorting in the data source configuration:

```dart
GenericGSheetsDataSource<ParishModel>(
  gsheetsService: sl(),
  sheetType: 'main',
  worksheetName: 'Parishes',
  fromJson: ParishModel.fromJson,
  // Filter only active parishes
  filterList: (items) => items.where((p) => p.isActive).toList(),
  // Sort by name
  sortList: (items) {
    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  },
)
```

## What You Save

**Before (Manual Implementation):**
- ~15 files per feature
- ~500-800 lines of boilerplate code
- DataSource implementations (remote + local)
- Repository implementation
- UseCase classes
- BLoC events, states, and logic
- Manual cache management
- Error handling duplication

**After (Generic Library):**
- 2-3 files per feature (Entity, Model, optionally custom widgets)
- ~100-150 lines of code
- Just configure dependency injection
- All boilerplate handled by the library

**Time savings: ~70% reduction in code and development time!**
