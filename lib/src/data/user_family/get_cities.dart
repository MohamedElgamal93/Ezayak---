class GetCities {
  int cityId;
  int govId;
  String cityName;
  String cityNameEn;

  GetCities({this.cityId, this.govId, this.cityName, this.cityNameEn});

  GetCities.fromJson(Map<String, dynamic> json) {
    cityId = json['cityId'];
    govId = json['govId'];
    cityName = json['cityName'];
    cityNameEn = json['cityNameEn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityId'] = this.cityId;
    data['govId'] = this.govId;
    data['cityName'] = this.cityName;
    data['cityNameEn'] = this.cityNameEn;
    return data;
  }
}
