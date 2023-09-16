import 'package:envied/envied.dart';

part 'api_keys_env.g.dart';

@Envied(path: 'api_keys.env')
abstract class Env {
  @EnviedField(varName: 'KAKAO_NATIVE_APP_KEY')
  static const String kakaoNativeKey = _Env.kakaoNativeKey;
  @EnviedField(varName: 'KAKAO_JAVASCRIPT_APP_KEY')
  static const String kakaoJSKey = _Env.kakaoJSKey;
  @EnviedField(varName: 'KAKAO_REST_API_KEY')
  static const String kakaoRestApiKey = _Env.kakaoRestApiKey;
  @EnviedField(varName: 'NAVER_MAP_KEY')
  static const String naverMapKey = _Env.naverMapKey;
  @EnviedField(varName: 'NAVER_MAP_CLIENT_ID')
  static const String naverMapClientId = _Env.naverMapClientId;
}
