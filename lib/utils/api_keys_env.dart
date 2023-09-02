import 'package:envied/envied.dart';

part 'api_keys_env.g.dart';

@Envied(path: 'api_keys.env')
abstract class Env {
  @EnviedField(varName: 'KAKAO_NATIVE_APP_KEY')
  static const String kakaoNativeKey = _Env.kakaoNativeKey;
  @EnviedField(varName: 'KAKAO_JAVASCRIPT_APP_KEY')
  static const String kakaoJSKey = _Env.kakaoJSKey;
}
