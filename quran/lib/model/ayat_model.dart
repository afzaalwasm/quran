class AyatModel {
  String? id;
  String? arabic;
  String? english;
  String? urdu;
  String? chiness;
  String? turkey;

  AyatModel(
      {this.id,
      this.arabic,
      this.english,
      this.urdu,
      this.chiness,
      this.turkey});

  AyatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    arabic = json['arabic'];
    english = json['english'];
    urdu = json['urdu'];
    chiness = json['chinese'];
    turkey = json['turkey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['arabic'] = arabic;
    data['english'] = english;
    data['urdu'] = urdu;
    data['chiness'] = chiness;
    data['turkey'] = turkey;
    return data;
  }
}
