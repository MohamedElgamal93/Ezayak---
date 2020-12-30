class GetGovernorates {
  int govId;
  String governorateName;

  GetGovernorates({this.govId, this.governorateName});

  GetGovernorates.fromJson(Map<String, dynamic> json) {
    govId = json['govId'];
    governorateName = json['governorateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['govId'] = this.govId;
    data['governorateName'] = this.governorateName;
    return data;
  }
}
