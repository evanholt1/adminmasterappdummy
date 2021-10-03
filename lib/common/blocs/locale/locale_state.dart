part of 'locale_cubit.dart';

abstract class LocaleState extends Equatable {
  const LocaleState();
}

class LocaleInitial extends LocaleState {
  @override
  List<Object> get props => [];
}

class LocaleSetSuccess extends LocaleState {
  final Locale locale;

  String get languageCode => locale.languageCode;
  String get countryCode => locale.countryCode!;
  bool get isEnglish => this.languageCode.compareTo("en") == 0;
  bool get isArabic => this.languageCode.compareTo("ar") == 0;

  const LocaleSetSuccess(this.locale);

  @override
  List<Object> get props => [this.locale];
}
