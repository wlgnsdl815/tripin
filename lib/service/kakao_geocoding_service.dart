import 'package:dio/dio.dart';
import 'package:tripin/model/map/kakao_geocoding_model.dart';
import 'package:tripin/utils/api_keys_env.dart';

class KaKaoGeocodingService {
  Dio dio = Dio();

  getGeoDataFromKakao({required double lat, required double lng}) async {
    String url =
        "https://dapi.kakao.com/v2/local/geo/coord2address.json?input_coord=WGS84&y=$lat&x=$lng";
    try {
      Response resp = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'KakaoAK ${Env.kakaoRestApiKey}',
          },
        ),
      );
      if (resp.statusCode == 200) {
        print('카카오에서 받은 데이터: ${resp.data['documents'].first['address']}');
        KakaoGeocodingModel kakaoGeocodingModel = KakaoGeocodingModel.fromMap(
            resp.data['documents'].first['address']);
        return kakaoGeocodingModel;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
