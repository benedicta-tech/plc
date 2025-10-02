import 'dart:async';

/// Simple local storage service for managing preacher data
/// This replaces the SQLite/Floor database with a simple in-memory storage
class LocalStorageService {
  // In-memory storage for preacher data
  final Map<String, dynamic> _storage = {};
  
  static const String _preachersKey = 'preachers';
  static const String _preachingThemesKey = 'preaching_themes';

  /// Initialize the storage with sample data
  Future<void> init() async {
    if (_storage.isEmpty) {
      await _loadSampleData();
    }
  }

  /// Load sample preacher data
  Future<void> _loadSampleData() async {
    final samplePreachers = [
      {
        'id': 1,
        'fullName': 'João Silva Santos',
        'phone': '(11) 99999-1234',
        'city': 'São Paulo',
        'state': 'SP',
      },
      {
        'id': 2,
        'fullName': 'Maria Oliveira Costa',
        'phone': '(21) 98888-5678',
        'city': 'Rio de Janeiro',
        'state': 'RJ',
      },
      {
        'id': 3,
        'fullName': 'Pedro Almeida Ferreira',
        'phone': '(31) 97777-9012',
        'city': 'Belo Horizonte',
        'state': 'MG',
      },
      {
        'id': 4,
        'fullName': 'Ana Paula Rodrigues',
        'phone': '(41) 96666-3456',
        'city': 'Curitiba',
        'state': 'PR',
      },
      {
        'id': 5,
        'fullName': 'Carlos Eduardo Lima',
        'phone': '(51) 95555-7890',
        'city': 'Porto Alegre',
        'state': 'RS',
      },
      {
        'id': 6,
        'fullName': 'Fernanda Souza Martins',
        'phone': '(61) 94444-2345',
        'city': 'Brasília',
        'state': 'DF',
      },
      {
        'id': 7,
        'fullName': 'Ricardo Santos Pereira',
        'phone': '(85) 93333-6789',
        'city': 'Fortaleza',
        'state': 'CE',
      },
      {
        'id': 8,
        'fullName': 'Juliana Mendes Silva',
        'phone': '(71) 92222-0123',
        'city': 'Salvador',
        'state': 'BA',
      }
    ];

    final sampleThemes = [
      {
        'id': 1,
        'title': 'Fé e Esperança',
        'description': 'A importância da fé em momentos difíceis',
      },
      {
        'id': 2,
        'title': 'Amor ao Próximo',
        'description': 'Como praticar o amor cristão no dia a dia',
      },
      {
        'id': 3,
        'title': 'Perdão e Reconciliação',
        'description': 'O poder transformador do perdão',
      },
    ];

    _storage[_preachersKey] = samplePreachers;
    _storage[_preachingThemesKey] = sampleThemes;
  }

  /// Get all preachers
  Future<List<Map<String, dynamic>>> getPreachers() async {
    await init();
    final data = _storage[_preachersKey] as List<dynamic>?;
    return data?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Get preacher by ID
  Future<Map<String, dynamic>?> getPreacherById(int id) async {
    await init();
    final preachers = await getPreachers();
    try {
      return preachers.firstWhere((preacher) => preacher['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new preacher
  Future<void> addPreacher(Map<String, dynamic> preacher) async {
    await init();
    final preachers = await getPreachers();
    
    // Generate new ID
    final maxId = preachers.isEmpty 
        ? 0 
        : preachers.map((p) => p['id'] as int).reduce((a, b) => a > b ? a : b);
    
    preacher['id'] = maxId + 1;
    preachers.add(preacher);
    _storage[_preachersKey] = preachers;
  }

  /// Update an existing preacher
  Future<void> updatePreacher(Map<String, dynamic> preacher) async {
    await init();
    final preachers = await getPreachers();
    final index = preachers.indexWhere((p) => p['id'] == preacher['id']);
    
    if (index != -1) {
      preachers[index] = preacher;
      _storage[_preachersKey] = preachers;
    }
  }

  /// Delete a preacher
  Future<void> deletePreacher(int id) async {
    await init();
    final preachers = await getPreachers();
    preachers.removeWhere((preacher) => preacher['id'] == id);
    _storage[_preachersKey] = preachers;
  }

  /// Get all preaching themes
  Future<List<Map<String, dynamic>>> getPreachingThemes() async {
    await init();
    final data = _storage[_preachingThemesKey] as List<dynamic>?;
    return data?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Clear all data (useful for testing)
  Future<void> clear() async {
    _storage.clear();
  }
}