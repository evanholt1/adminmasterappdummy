class LocalizedText {
  final String en;
  final String ar;

  LocalizedText({required this.en, required this.ar});

  LocalizedText.fromJson(Map<String, dynamic> json)
      : this.en = json['en'],
        this.ar = json['ar'];
}
