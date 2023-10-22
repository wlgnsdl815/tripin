// ignore_for_file: public_member_api_docs, sort_constructors_first
class GeocodingModel {
  final List<GeocodingResult> results;
  GeocodingModel({
    required this.results,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'results': results.map((x) => x.toMap()).toList(),
    };
  }

  factory GeocodingModel.fromMap(Map<String, dynamic> map) {
    return GeocodingModel(
      results: List<GeocodingResult>.from(
        (map['results'] as List<Map<String, dynamic>>).map<GeocodingResult>(
          (x) => GeocodingResult.fromMap(x),
        ),
      ),
    );
  }
}

class GeocodingResult {
  final Region region;
  final String? buildingName;

  GeocodingResult({
    required this.region,
    this.buildingName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'region': region.toMap(),
      'buildingName': buildingName,
    };
  }

  factory GeocodingResult.fromMap(Map<String, dynamic> map) {
    return GeocodingResult(
      region: Region.fromMap(map['region'] as Map<String, dynamic>),
      buildingName: map['addition0']?['value'] as String? ?? '',
    );
  }
  @override
  String toString() {
    return 'GeocodingResult(region: $region)';
  }
}

class Region {
  final String area1Name;
  final String area2Name;
  final String area3Name;
  final String area4Name;

  Region({
    required this.area1Name,
    required this.area2Name,
    required this.area3Name,
    required this.area4Name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'area1Name': area1Name,
      'area2Name': area2Name,
      'area3Name': area3Name,
      'area4Name': area4Name,
    };
  }

  factory Region.fromMap(Map<String, dynamic> map) {
    return Region(
      area1Name: map['area1']['name'] as String? ?? '',
      area2Name: map['area2']['name'] as String? ?? '',
      area3Name: map['area3']['name'] as String? ?? '',
      area4Name: map['area4']['name'] as String? ?? '',
    );
  }

  String toString() {
    return 'Region(area1Name: $area1Name, area2Name: $area2Name, area3Name: $area3Name, area4Name: $area4Name)';
  }
}
