import 'package:equatable/equatable.dart';

class MapPredictionEntity extends Equatable {
  String? secondaryText;
  String? mainText;
  String? placeId;

  MapPredictionEntity(
      {required this.secondaryText,
      required this.mainText,
      required this.placeId});

  @override
  // TODO: implement props
  List<Object?> get props => [secondaryText, mainText, placeId];
}
