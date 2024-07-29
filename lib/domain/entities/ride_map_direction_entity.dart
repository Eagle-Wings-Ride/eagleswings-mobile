import 'package:equatable/equatable.dart';

class RideMapDirectionEntity extends Equatable {
  int? distanceValue;
  int? durationValue;
  String? distanceText;
  String? durationText;
  String? enCodedPoints; //for polyline

  RideMapDirectionEntity(
      {required this.distanceValue,
      required this.durationValue,
      required this.distanceText,
      required this.durationText,
      required this.enCodedPoints});

  @override
  // TODO: implement props
  List<Object?> get props =>
      [distanceValue, durationValue, distanceText, durationText, enCodedPoints];
}
