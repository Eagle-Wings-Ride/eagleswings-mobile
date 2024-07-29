

// import 'dart:convert';

// Direction directionFromJson(String str) => Direction.fromJson(json.decode(str));

// String directionToJson(Direction data) => json.encode(data.toJson());

// class Direction {
//   Direction({
//     this.geocodedWaypoints,
//     this.routes,
//     this.status,
//   });

//   List<GeocodedWaypoint>? geocodedWaypoints;
//   List<Route>? routes;
//   String? status;

//   factory Direction.fromJson(Map<String, dynamic> json) => Direction(
//         geocodedWaypoints: List<GeocodedWaypoint>.from(
//             json["geocoded_waypoints"]
//                 .map((x) => GeocodedWaypoint.fromJson(x))),
//         routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
//         status: json["status"],
//       );

//   Map<String, dynamic> toJson() => {
//         "geocoded_waypoints":
//             List<dynamic>.from(geocodedWaypoints!.map((x) => x.toJson())),
//         "routes": List<dynamic>.from(routes!.map((x) => x.toJson())),
//         "status": status,
//       };
// }

// class GeocodedWaypoint {
//   GeocodedWaypoint({
//     this.geocoderStatus,
//     this.placeId,
//     this.types,
//   });

//   String? geocoderStatus;
//   String? placeId;
//   List<String>? types;

//   factory GeocodedWaypoint.fromJson(Map<String, dynamic> json) =>
//       GeocodedWaypoint(
//         geocoderStatus: json["geocoder_status"],
//         placeId: json["place_id"],
//         types: List<String>.from(json["types"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "geocoder_status": geocoderStatus,
//         "place_id": placeId,
//         "types": List<dynamic>.from(types!.map((x) => x)),
//       };
// }

// class Route {
//   Route({
//     this.bounds,
//     this.copyrights,
//     this.legs,
//     this.overviewPolyline,
//     this.summary,
//     this.warnings,
//     this.waypointOrder,
//   });

//   Bounds? bounds;
//   String? copyrights;
//   List<Leg>? legs;
//   Polyline? overviewPolyline;
//   String? summary;
//   List<dynamic>? warnings;
//   List<dynamic>? waypointOrder;

//   factory Route.fromJson(Map<String, dynamic> json) => Route(
//         bounds: Bounds.fromJson(json["bounds"]),
//         copyrights: json["copyrights"],
//         legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
//         overviewPolyline: Polyline.fromJson(json["overview_polyline"]),
//         summary: json["summary"],
//         warnings: List<dynamic>.from(json["warnings"].map((x) => x)),
//         waypointOrder: List<dynamic>.from(json["waypoint_order"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "bounds": bounds!.toJson(),
//         "copyrights": copyrights,
//         "legs": List<dynamic>.from(legs!.map((x) => x.toJson())),
//         "overview_polyline": overviewPolyline!.toJson(),
//         "summary": summary,
//         "warnings": List<dynamic>.from(warnings!.map((x) => x)),
//         "waypoint_order": List<dynamic>.from(waypointOrder!.map((x) => x)),
//       };
// }

// class Bounds {
//   Bounds({
//     this.northeast,
//     this.southwest,
//   });

//   Northeast? northeast;
//   Northeast? southwest;

//   factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
//         northeast: Northeast.fromJson(json["northeast"]),
//         southwest: Northeast.fromJson(json["southwest"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "northeast": northeast!.toJson(),
//         "southwest": southwest!.toJson(),
//       };
// }

// class Northeast {
//   Northeast({
//     this.lat,
//     this.lng,
//   });

//   double? lat;
//   double? lng;

//   factory Northeast.fromJson(Map<String, dynamic> json) => Northeast(
//         lat: json["lat"].toDouble(),
//         lng: json["lng"].toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "lat": lat,
//         "lng": lng,
//       };
// }

// class Leg {
//   Leg({
//     this.distance,
//     this.duration,
//     this.endAddress,
//     this.endLocation,
//     this.startAddress,
//     this.startLocation,
//     this.steps,
//     this.trafficSpeedEntry,
//     this.viaWaypoint,
//   });

//   Distance? distance;
//   Distance? duration;
//   String? endAddress;
//   Northeast? endLocation;
//   String? startAddress;
//   Northeast? startLocation;
//   List<Step>? steps;
//   List<dynamic>? trafficSpeedEntry;
//   List<dynamic>? viaWaypoint;

//   factory Leg.fromJson(Map<String, dynamic> json) => Leg(
//         distance: Distance.fromJson(json["distance"]),
//         duration: Distance.fromJson(json["duration"]),
//         endAddress: json["end_address"],
//         endLocation: Northeast.fromJson(json["end_location"]),
//         startAddress: json["start_address"],
//         startLocation: Northeast.fromJson(json["start_location"]),
//         steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
//         trafficSpeedEntry:
//             List<dynamic>.from(json["traffic_speed_entry"].map((x) => x)),
//         viaWaypoint: List<dynamic>.from(json["via_waypoint"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "distance": distance!.toJson(),
//         "duration": duration!.toJson(),
//         "end_address": endAddress,
//         "end_location": endLocation!.toJson(),
//         "start_address": startAddress,
//         "start_location": startLocation!.toJson(),
//         "steps": List<dynamic>.from(steps!.map((x) => x.toJson())),
//         "traffic_speed_entry":
//             List<dynamic>.from(trafficSpeedEntry!.map((x) => x)),
//         "via_waypoint": List<dynamic>.from(viaWaypoint!.map((x) => x)),
//       };
// }

// class Distance {
//   Distance({
//     this.text,
//     this.value,
//   });

//   String? text;
//   int? value;

//   factory Distance.fromJson(Map<String, dynamic> json) => Distance(
//         text: json["text"],
//         value: json["value"],
//       );

//   Map<String, dynamic> toJson() => {
//         "text": text,
//         "value": value,
//       };
// }

// class Step {
//   Step({
//     this.distance,
//     this.duration,
//     this.endLocation,
//     this.htmlInstructions,
//     this.polyline,
//     this.startLocation,
//     this.travelMode,
//     this.maneuver,
//   });

//   Distance? distance;
//   Distance? duration;
//   Northeast? endLocation;
//   String? htmlInstructions;
//   Polyline? polyline;
//   Northeast? startLocation;
//   TravelMode? travelMode;
//   String? maneuver;

//   factory Step.fromJson(Map<String, dynamic> json) => Step(
//         distance: Distance.fromJson(json["distance"]),
//         duration: Distance.fromJson(json["duration"]),
//         endLocation: Northeast.fromJson(json["end_location"]),
//         htmlInstructions: json["html_instructions"],
//         polyline: Polyline.fromJson(json["polyline"]),
//         startLocation: Northeast.fromJson(json["start_location"]),
//         travelMode: travelModeValues.map[json["travel_mode"]],
//         maneuver: json["maneuver"],
//       );

//   Map<String, dynamic> toJson() => {
//         "distance": distance!.toJson(),
//         "duration": duration!.toJson(),
//         "end_location": endLocation!.toJson(),
//         "html_instructions": htmlInstructions,
//         "polyline": polyline!.toJson(),
//         "start_location": startLocation!.toJson(),
//         "travel_mode": travelModeValues.reverse[travelMode],
//         "maneuver": maneuver,
//       };
// }

// class Polyline {
//   Polyline({
//     this.points,
//   });

//   String? points;

//   factory Polyline.fromJson(Map<String, dynamic> json) => Polyline(
//         points: json["points"],
//       );

//   Map<String, dynamic> toJson() => {
//         "points": points,
//       };
// }

// enum TravelMode { DRIVING }

// final travelModeValues = EnumValues({"DRIVING": TravelMode.DRIVING});

// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap = {};

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }


import 'dart:convert';

Direction directionFromJson(String str) => Direction.fromJson(json.decode(str));

String directionToJson(Direction data) => json.encode(data.toJson());

class Direction {
  Direction({
    this.geocodedWaypoints,
    this.routes,
    this.status,
  });

  List<GeocodedWaypoint>? geocodedWaypoints;
  List<Route>? routes;
  String? status;

  factory Direction.fromJson(Map<String, dynamic> json) {
    print("Parsing Direction JSON: $json"); // Debugging line

    return Direction(
      geocodedWaypoints: json["geocoded_waypoints"] != null
          ? List<GeocodedWaypoint>.from(json["geocoded_waypoints"]
              .map((x) => GeocodedWaypoint.fromJson(x as Map<String, dynamic>)))
          : <GeocodedWaypoint>[],
      routes: json["routes"] != null
          ? List<Route>.from(
              json["routes"].map((x) => Route.fromJson(x as Map<String, dynamic>)))
          : <Route>[],
      status: json["status"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        "geocoded_waypoints": geocodedWaypoints != null
            ? List<dynamic>.from(geocodedWaypoints!.map((x) => x.toJson()))
            : <GeocodedWaypoint>[],
        "routes": routes != null
            ? List<dynamic>.from(routes!.map((x) => x.toJson()))
            : <Route>[],
        "status": status,
      };
}

class GeocodedWaypoint {
  GeocodedWaypoint({
    this.geocoderStatus,
    this.placeId,
    this.types,
  });

  String? geocoderStatus;
  String? placeId;
  List<String>? types;

  factory GeocodedWaypoint.fromJson(Map<String, dynamic> json) =>
      GeocodedWaypoint(
        geocoderStatus: json["geocoder_status"] as String?,
        placeId: json["place_id"] as String?,
        types: json["types"] != null
            ? List<String>.from(json["types"].map((x) => x as String))
            : <String>[],
      );

  Map<String, dynamic> toJson() => {
        "geocoder_status": geocoderStatus,
        "place_id": placeId,
        "types": types != null
            ? List<dynamic>.from(types!.map((x) => x))
            : <String>[],
      };
}

class Route {
  Route({
    this.bounds,
    this.copyrights,
    this.legs,
    this.overviewPolyline,
    this.summary,
    this.warnings,
    this.waypointOrder,
  });

  Bounds? bounds;
  String? copyrights;
  List<Leg>? legs;
  Polyline? overviewPolyline;
  String? summary;
  List<dynamic>? warnings;
  List<dynamic>? waypointOrder;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        bounds: json["bounds"] != null ? Bounds.fromJson(json["bounds"]) : null,
        copyrights: json["copyrights"] as String?,
        legs: json["legs"] != null
            ? List<Leg>.from(
                json["legs"].map((x) => Leg.fromJson(x as Map<String, dynamic>)))
            : <Leg>[],
        overviewPolyline: json["overview_polyline"] != null
            ? Polyline.fromJson(json["overview_polyline"])
            : null,
        summary: json["summary"] as String?,
        warnings: json["warnings"] != null
            ? List<dynamic>.from(json["warnings"].map((x) => x))
            : <dynamic>[],
        waypointOrder: json["waypoint_order"] != null
            ? List<dynamic>.from(json["waypoint_order"].map((x) => x))
            : <dynamic>[],
      );

  Map<String, dynamic> toJson() => {
        "bounds": bounds?.toJson(),
        "copyrights": copyrights,
        "legs": legs != null
            ? List<dynamic>.from(legs!.map((x) => x.toJson()))
            : <Leg>[],
        "overview_polyline": overviewPolyline?.toJson(),
        "summary": summary,
        "warnings": warnings != null
            ? List<dynamic>.from(warnings!.map((x) => x))
            : <dynamic>[],
        "waypoint_order": waypointOrder != null
            ? List<dynamic>.from(waypointOrder!.map((x) => x))
            : <dynamic>[],
      };
}

class Bounds {
  Bounds({
    this.northeast,
    this.southwest,
  });

  Northeast? northeast;
  Northeast? southwest;

  factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
        northeast: json["northeast"] != null
            ? Northeast.fromJson(json["northeast"])
            : null,
        southwest: json["southwest"] != null
            ? Northeast.fromJson(json["southwest"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
      };
}

class Northeast {
  Northeast({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory Northeast.fromJson(Map<String, dynamic> json) => Northeast(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Leg {
  Leg({
    this.distance,
    this.duration,
    this.endAddress,
    this.endLocation,
    this.startAddress,
    this.startLocation,
    this.steps,
    this.trafficSpeedEntry,
    this.viaWaypoint,
  });

  Distance? distance;
  Distance? duration;
  String? endAddress;
  Northeast? endLocation;
  String? startAddress;
  Northeast? startLocation;
  List<Step>? steps;
  List<dynamic>? trafficSpeedEntry;
  List<dynamic>? viaWaypoint;

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        distance: json["distance"] != null
            ? Distance.fromJson(json["distance"])
            : null,
        duration: json["duration"] != null
            ? Distance.fromJson(json["duration"])
            : null,
        endAddress: json["end_address"] as String?,
        endLocation: json["end_location"] != null
            ? Northeast.fromJson(json["end_location"])
            : null,
        startAddress: json["start_address"] as String?,
        startLocation: json["start_location"] != null
            ? Northeast.fromJson(json["start_location"])
            : null,
        steps: json["steps"] != null
            ? List<Step>.from(
                json["steps"].map((x) => Step.fromJson(x as Map<String, dynamic>)))
            : <Step>[],
        trafficSpeedEntry: json["traffic_speed_entry"] != null
            ? List<dynamic>.from(json["traffic_speed_entry"].map((x) => x))
            : <dynamic>[],
        viaWaypoint: json["via_waypoint"] != null
            ? List<dynamic>.from(json["via_waypoint"].map((x) => x))
            : <dynamic>[],
      );

  Map<String, dynamic> toJson() => {
        "distance": distance?.toJson(),
        "duration": duration?.toJson(),
        "end_address": endAddress,
        "end_location": endLocation?.toJson(),
        "start_address": startAddress,
        "start_location": startLocation?.toJson(),
        "steps": steps != null
            ? List<dynamic>.from(steps!.map((x) => x.toJson()))
            : <Step>[],
        "traffic_speed_entry": trafficSpeedEntry != null
            ? List<dynamic>.from(trafficSpeedEntry!.map((x) => x))
            : <dynamic>[],
        "via_waypoint": viaWaypoint != null
            ? List<dynamic>.from(viaWaypoint!.map((x) => x))
            : <dynamic>[],
      };
}

class Distance {
  Distance({
    this.text,
    this.value,
  });

  String? text;
  int? value;

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        text: json["text"] as String?,
        value: json["value"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
      };
}

class Step {
  Step({
    this.distance,
    this.duration,
    this.endLocation,
    this.htmlInstructions,
    this.polyline,
    this.startLocation,
    this.travelMode,
    this.maneuver,
  });

  Distance? distance;
  Distance? duration;
  Northeast? endLocation;
  String? htmlInstructions;
  Polyline? polyline;
  Northeast? startLocation;
  TravelMode? travelMode;
  String? maneuver;

  factory Step.fromJson(Map<String, dynamic> json) => Step(
        distance: json["distance"] != null
            ? Distance.fromJson(json["distance"])
            : null,
        duration: json["duration"] != null
            ? Distance.fromJson(json["duration"])
            : null,
        endLocation: json["end_location"] != null
            ? Northeast.fromJson(json["end_location"])
            : null,
        htmlInstructions: json["html_instructions"] as String?,
        polyline: json["polyline"] != null
            ? Polyline.fromJson(json["polyline"])
            : null,
        startLocation: json["start_location"] != null
            ? Northeast.fromJson(json["start_location"])
            : null,
        travelMode: json["travel_mode"] != null
            ? travelModeValues.map[json["travel_mode"] as String]
            : null,
        maneuver: json["maneuver"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "distance": distance?.toJson(),
        "duration": duration?.toJson(),
        "end_location": endLocation?.toJson(),
        "html_instructions": htmlInstructions,
        "polyline": polyline?.toJson(),
        "start_location": startLocation?.toJson(),
        "travel_mode": travelMode != null
            ? travelModeValues.reverse[travelMode]
            : null,
        "maneuver": maneuver,
      };
}

class Polyline {
  Polyline({
    this.points,
  });

  String? points;

  factory Polyline.fromJson(Map<String, dynamic> json) => Polyline(
        points: json["points"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "points": points,
      };
}

enum TravelMode { DRIVING }

final travelModeValues = EnumValues({"DRIVING": TravelMode.DRIVING});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
