import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'GOOGLE_SERVICE_ACCOUNT')
  static final String googleServiceAccount = _Env.googleServiceAccount;
}
