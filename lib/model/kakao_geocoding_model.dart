class KakaoGeocodingModel {
  final String? addressName;
  final String? region1depthName;
  final String? region2depthName;
  final String? region3depthName;
  final String? mountainYn;
  final String? mainAddressNo;
  final String? subAddressNo;
  final String? zipCode;

  KakaoGeocodingModel({
    required this.addressName,
    required this.region1depthName,
    required this.region2depthName,
    required this.region3depthName,
    required this.mountainYn,
    required this.mainAddressNo,
    required this.subAddressNo,
    required this.zipCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'addressName': addressName,
      'region1depthName': region1depthName,
      'region2depthName': region2depthName,
      'region3depthName': region3depthName,
      'mountainYn': mountainYn,
      'mainAddressNo': mainAddressNo,
      'subAddressNo': subAddressNo,
      'zipCode': zipCode,
    };
  }

  factory KakaoGeocodingModel.fromMap(Map<String, dynamic> map) {
    return KakaoGeocodingModel(
      addressName: map['address_name'] as String? ?? '',
      region1depthName: map['region_1depth_name'] as String? ?? '',
      region2depthName: map['region_2depth_name'] as String? ?? '',
      region3depthName: map['region_3depth_name'] as String? ?? '',
      mountainYn: map['mountain_yn'] as String? ?? '',
      mainAddressNo: map['main_address_no'] as String? ?? '',
      subAddressNo: map['sub_address_no'] as String? ?? '',
      zipCode: map['zip_code'] as String? ?? '',
    );
  }
}
