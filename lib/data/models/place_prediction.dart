class Placeprediction {
  final String placeId;
  final String mainText;
  final String secondaryText;

  Placeprediction({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });

  factory Placeprediction.fromJson(Map<String, dynamic> json) {
    return Placeprediction(
      placeId: json['place_id'],
      mainText: json['structured_formatting']['main_text'],
      secondaryText: json['structured_formatting']['secondary_text'],
    );
  }
}