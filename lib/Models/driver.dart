import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  final String id;
  final String name;
  final String? phoneNumber;

  Driver.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.id = json['_id'],
        this.phoneNumber = json['phone_number'];

  static listFromJson(List json) =>
      json.map((e) => Driver.fromJson(e)).toList(growable: false);

  @override
  List<Object?> get props => [id];
}
