import 'place_prediction.dart';

class PlacePredictor {
  final String placeId;
  final String mainText;
  final String secondaryText;

  PlacePredictor({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlacePredictor.fromPrediction(Placeprediction prediction) {
    return PlacePredictor(
      placeId: prediction.placeId,
      mainText: prediction.mainText,
      secondaryText: prediction.secondaryText,
    );
  }
}
