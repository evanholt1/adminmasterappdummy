import 'package:admin_eshop/Models/LocalizedText.dart';
import 'package:equatable/equatable.dart';

class AddonOption with EquatableMixin {
  final String id;
  final LocalizedText name;
  final num price;

  AddonOption({required this.id, required this.name, required this.price});

  @override
  List<Object> get props => [id];

  toJson() => {
        "_id": this.id,
        "name": this.name,
        "price": this.price,
      };

  AddonOption.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = LocalizedText.fromJson(json['name']),
        price = json['price'];
}
