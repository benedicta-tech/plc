import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/daily_reading/presentation/widgets/liturgy_header.dart';

void main() {
  test('formata a data por extenso em português', () {
    expect(
      formatLiturgyDate(DateTime(2026, 7, 26)),
      'Domingo, 26 de Julho de 2026',
    );
  });
}
