class Driver {
  final String name;
  final String? phoneNumber;

  Driver.fromJson(Map<String,dynamic> json)
  : this.name = json['name'],
  this.phoneNumber = json['phone_number'];
}