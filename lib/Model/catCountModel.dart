import 'package:admin_eshop/Helper/String.dart';

class catCountModel {
  String catName;
  int count;

  catCountModel({this.catName, this.count});

  factory catCountModel.fromJson(Map<String, dynamic> json) {
    return new catCountModel(
        catName: json[CATNAME],
        count: json[COUNT],
    
      );
  }
}
