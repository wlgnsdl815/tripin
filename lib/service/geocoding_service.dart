import 'package:dio/dio.dart';
import 'package:tripin/model/geocoding_model.dart';
import 'package:tripin/utils/api_keys_env.dart';

class GeocodingService {
  Future<List<GeocodingResult>> naverReverseGeocode(
      double lat, double lng) async {
    String url =
        ('https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lng,$lat&sourcecrs=epsg:4326&output=json&orders=addr,admcode,roadaddr');

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
      var dataList = List<Map<String, dynamic>>.from(response.data['results']);
      List<GeocodingResult> resultList =
          dataList.map((e) => GeocodingResult.fromMap(e)).toList();
      print(response.data);

      print(resultList);

      return resultList;
    } catch (e) {
      throw Exception(e);
    }
  }
}
