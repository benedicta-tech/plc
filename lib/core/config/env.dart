import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GOOGLE_SERVICE_ACCOUNT', rawString: true)
  static final String googleServiceAccount = _Env.googleServiceAccount;
}
