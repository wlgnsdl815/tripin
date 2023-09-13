import 'package:dio/dio.dart';
import 'package:tripin/utils/api_keys_env.dart';

class GeocodingService {
  Future<Map<String, dynamic>> naverReverseGeocode(
      double lat, double lng) async {
    String url =
        ('https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$lat,$lng&orders=legalcode,admcode,addr,roadaddr&output=json');

    Dio dio = Dio();

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'X-NCP-APIGW-API-KEY-ID': Env.naverMapClientId,
            'X-NCP-APIGW-API-KEY': Env.naverMapKey,
          },
        ),
      );
      print(response.data);
      return (response.data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
