import 'package:admin_eshop/Models/AddonOption.dart';
import 'package:admin_eshop/Models/LocalizedText.dart';
import 'package:equatable/equatable.dart';

class AddonCategory extends Equatable {
  final String id;
  final LocalizedText name;
  List<AddonOption> options;
  final int minSelection;
  final int maxSelection;

  AddonCategory(
      {required this.id,
      required this.name,
      this.options = const [],
      required this.minSelection,
      required this.maxSelection});

  toJson() => {
        "_id": id,
        "name": name,
        "min_selection": this.minSelection,
        "max_selection": this.maxSelection,
        "options": options,
      };

  AddonCategory.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = LocalizedText.fromJson(json['name']),
        maxSelection = json['max_selection'],
        minSelection = json['min_selection'],
        options = (json['options'] as List)
            .map((opJson) => AddonOption.fromJson(opJson))
            .toList();

  static List<AddonCategory> addonCategoriesFromJson(List json) =>
      json.map((e) => AddonCategory.fromJson(e)).toList();

  @override
  List<Object?> get props => [id];

  static List<AddonCategory> copyList(List<AddonCategory> addonCats) {
    List<AddonCategory> newList = [];
    addonCats.forEach((element) => AddonCategory(
          id: element.id,
          name: LocalizedText.copy(element.name),
          minSelection: element.minSelection,
          maxSelection: element.maxSelection,
          options: AddonOption.copyList(element.options),
        ));
    return newList;
  }
}
