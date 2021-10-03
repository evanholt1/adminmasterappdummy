import 'package:equatable/equatable.dart';

class LocalizedText extends Equatable {
  late String? en;
  late String? ar;

  LocalizedText({required this.en, required this.ar});

  LocalizedText.optional();

  LocalizedText.fromJson(Map<String, dynamic> json)
      : this.en = json['en'],
        this.ar = json['ar'];

  static LocalizedText copy(LocalizedText text) =>
      LocalizedText(en: text.en, ar: text.ar);

  @override
  List<Object?> get props => [en, ar];

  @override
  bool? get stringify => true;
}
