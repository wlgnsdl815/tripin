import 'package:dio/dio.dart';

class KakaoService {
  Dio dio = Dio();

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    try {
      final customTokenResponse = await dio.post(
          'https://createcustomtoken-eykungydua-uc.a.run.app',
          data: user);
      if (customTokenResponse.statusCode == 200) {
        return customTokenResponse.data;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
