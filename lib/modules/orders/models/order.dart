import 'package:admin_eshop/Models/driver.dart';
import 'package:admin_eshop/modules/orders/enums/order_status.dart';

class Order {
  final bool reviewed;
  final List<OrderItem> items;
  final Driver? driver;
  final String id;
  final String username;
  final String? userPhoneNumber;
  final num deliveryFee;
  final num? subTotal;
  final double tax;
  final String paymentType;
  final String? promocode;
  final num? promocodeValue;
  final double totalPrice;
  final DeliveryAddress deliveryAddress;
  final int totalQuantity;
  final DateTime orderDate;
  final OrderStatus status;

  String get displayId => this.id.substring(18);

  Order({
    required this.reviewed,
    required this.items,
    this.driver,
    required this.id,
    required this.username,
    this.userPhoneNumber,
    required this.deliveryFee,
    this.subTotal,
    required this.tax,
    required this.paymentType,
    this.promocode,
    this.promocodeValue,
    required this.totalPrice,
    required this.deliveryAddress,
    required this.totalQuantity,
    required this.orderDate,
    required this.status,
  });

  static List<Order> listFromJson(List json) => json.map((e) => Order.fromJson(e)).toList();

  Order.fromJson(Map<String, dynamic> json)
      : reviewed = json['reviewed'],
        driver = json['driver'] == null ? null : Driver.fromJson(json['driver']),
        items = OrderItem.listFromJson(json['items'] as List),
        username = json['user']['name'],
        userPhoneNumber = json['user.phone_number'],
        deliveryFee = json['deliveryFee'],
        tax = json['tax'],
        subTotal = json['subTotal'],
        paymentType = json['paymentType'],
        promocode = json['promocode'],
        promocodeValue = json['promocodeValue'],
        totalPrice = json['totalPrice'],
        deliveryAddress = DeliveryAddress.fromJson(json['deliveryAddress']),
        totalQuantity = json['totalQuantity'],
        orderDate = DateTime.parse(json['createdAt']),
        status = OrderStatus.values[json['status']],
        id = json['_id'];
}

class OrderItem {
  final String id;
  final int quantity;
  final num totalItemPrice;
  final List<SelectedAddonCat> selectedAddonCats;
  final String name;

  OrderItem(
      {required this.id,
      required this.quantity,
      required this.totalItemPrice,
      required this.selectedAddonCats,
      required this.name});

  OrderItem.fromJson(Map<String, dynamic> json)
      : id = json['item'],
        quantity = json['quantity'],
        totalItemPrice = json['totalItemPrice'],
        name = (json['name'] as Map).values.first,
        selectedAddonCats = SelectedAddonCat.listFromJson(json['selectedAddonCats']);

  static listFromJson(List json) => json.map((e) => OrderItem.fromJson(e)).toList();
}

class SelectedAddonCat {
  final String id;
  final String name;
  final List<SelectedOption> selectedOptions;

  SelectedAddonCat({required this.id, required this.selectedOptions, required this.name});

  SelectedAddonCat.fromJson(Map<String, dynamic> json)
      : this.id = json['_id'],
        this.name = (json['name'] as Map).values.first,
        this.selectedOptions = SelectedOption.listFromJson(json['selectedOptions']);

  static listFromJson(List json) => json.map((e) => SelectedAddonCat.fromJson(e)).toList();
}

class SelectedOption {
  final String id;
  final num price;
  final String name;

  SelectedOption({required this.id, required this.price, required this.name});

  SelectedOption.fromJson(Map<String, dynamic> json)
      : this.id = json['_id'],
        this.price = json['price'],
        this.name = (json['name'] as Map).values.first;

  static listFromJson(List json) => json.map((e) => SelectedOption.fromJson(e)).toList();
}

// class Location {
//   String type;
//   List<double> coordinates;
//
//   Location({this.type, this.coordinates});
//
//   Location.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     coordinates = json['coordinates'].cast<double>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['type'] = this.type;
//     data['coordinates'] = this.coordinates;
//     return data;
//   }
// }

class DeliveryAddress {
  final String? streetAddress;
  final String? buildingVillNumber;
  final String? floorNumber;
  final String? apartmentNumber;
  final num lat;
  final num long;
  final String? governorate;
  final String? area;

  DeliveryAddress({
    this.streetAddress,
    this.buildingVillNumber,
    this.floorNumber,
    this.apartmentNumber,
    this.governorate,
    this.area,
    required this.lat,
    required this.long,
  });

  DeliveryAddress.fromJson(Map<String, dynamic> json)
      : this.streetAddress = json['streetAddress'],
        this.floorNumber = json['floorNumber'],
        this.buildingVillNumber = json['buildingVillNumber'],
        this.apartmentNumber = json['apartmentNumber'],
        this.governorate = json['governorate'],
        this.area = json['area'],
        this.lat = json['position']['coordinates'][1],
        this.long = json['position']['coordinates'][0];
}
