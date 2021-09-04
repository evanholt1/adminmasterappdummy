import 'package:admin_eshop/Helper/String.dart';

class PersonModel {
  String id, name, email, img, status, balance, mobile, city, area, street;

  PersonModel(
      {this.id,
      this.name,
      this.email,
      this.img,
      this.status,
      this.balance,
      this.mobile,
      this.city,
      this.area,
      this.street});

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return new PersonModel(
        id: json[ID],
        name: json[NAME],
        email: json[EMAIL],
        img: json[IMAGE],
        status: json[STATUS],
        mobile: json[MOBILE],
        city: json[CITY] ?? "",
        area: json[AREA] ?? "",
        street: json[STREET] ?? "",
        balance: json[BALANCE]);
  }

   @override
  String toString() {
    return this.name;
  }

  
  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }
}
