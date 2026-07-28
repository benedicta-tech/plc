import 'package:plc/core/features/core_features.dart';
import 'package:plc/core/storage/gsheets_storage_service.dart';
import 'package:plc/core/storage/local_storage_service.dart';
import 'package:plc/features/parishes/data/models/member_model.dart';
import 'package:plc/features/parishes/domain/entities/member.dart';

/// Cada paróquia tem sua própria aba de membros, então o repositório não pode
/// ser um singleton com worksheetName fixo como as outras features. A fábrica
/// monta um por aba, sob demanda, e guarda para a próxima abertura do perfil.
class MembersRepositoryFactory {
  final GSheetsStorageService gsheetsService;
  final LocalStorageService storageService;
  final int cacheDurationInDays;

  final Map<String, GenericRepository<Member>> _repositories = {};

  MembersRepositoryFactory({
    required this.gsheetsService,
    required this.storageService,
    this.cacheDurationInDays = 1,
  });

  static String storageKeyFor(String worksheetName) {
    final slug = worksheetName
        .toLowerCase()
        .replaceAll(RegExp(r'[àáâãä]'), 'a')
        .replaceAll(RegExp(r'[èéêë]'), 'e')
        .replaceAll(RegExp(r'[ìíîï]'), 'i')
        .replaceAll(RegExp(r'[òóôõö]'), 'o')
        .replaceAll(RegExp(r'[ùúûü]'), 'u')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return 'members_$slug';
  }

  static String syncKeyFor(String worksheetName) =>
      '${storageKeyFor(worksheetName)}_last_sync';

  GenericRepository<Member> forSheet(String worksheetName) {
    return _repositories.putIfAbsent(
      worksheetName,
      () => GenericCachedRepository<Member, MemberModel>(
        remoteDataSource: GenericGSheetsDataSource<MemberModel>(
          gsheetsService: gsheetsService,
          sheetType: 'main',
          worksheetName: worksheetName,
          fromJson: MemberModel.fromJson,
          filterList: _semLinhasVazias,
        ),
        localDataSource: GenericLocalDataSourceImpl<MemberModel>(
          storageService: storageService,
          storageKey: storageKeyFor(worksheetName),
          syncDateKey: syncKeyFor(worksheetName),
          fromJson: MemberModel.fromJson,
          filterList: _semLinhasVazias,
        ),
        cacheDurationInDays: cacheDurationInDays,
      ),
    );
  }

  static List<MemberModel> _semLinhasVazias(List<MemberModel> items) =>
      items.where((m) => m.name.isNotEmpty && m.role.isNotEmpty).toList();
}
