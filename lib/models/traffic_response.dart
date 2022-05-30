// To parse this JSON data, do
//
//     final trafficResponse = trafficResponseFromMap(jsonString);

import 'dart:convert';

class TrafficResponse {
  TrafficResponse({
    required this.routes,
    required this.waypoints,
    required this.code,
    required this.uuid,
  });

  final List<Route> routes;
  final List<Waypoint> waypoints;
  final String code;
  final String uuid;

  factory TrafficResponse.fromJson(String str) =>
      TrafficResponse.fromMap(json.decode(str));

  factory TrafficResponse.fromMap(Map<String, dynamic> json) => TrafficResponse(
        routes: List<Route>.from(json["routes"].map((x) => Route.fromMap(x))),
        waypoints: List<Waypoint>.from(
            json["waypoints"].map((x) => Waypoint.fromMap(x))),
        code: json["code"],
        uuid: json["uuid"],
      );
}

class Route {
  Route({
    required this.countryCrossed,
    required this.weightName,
    required this.weight,
    required this.duration,
    required this.distance,
    required this.legs,
    required this.geometry,
  });

  final bool countryCrossed;
  final String weightName;
  final double weight;
  final double duration;
  final double distance;
  final List<Leg> legs;
  final String geometry;

  factory Route.fromJson(String str) => Route.fromMap(json.decode(str));

  factory Route.fromMap(Map<String, dynamic> json) => Route(
        countryCrossed: json["country_crossed"],
        weightName: json["weight_name"],
        weight: json["weight"].toDouble(),
        duration: json["duration"].toDouble(),
        distance: json["distance"].toDouble(),
        legs: List<Leg>.from(json["legs"].map((x) => Leg.fromMap(x))),
        geometry: json["geometry"],
      );
}

class Leg {
  Leg({
    required this.viaWaypoints,
    required this.admins,
    required this.weight,
    required this.duration,
    required this.steps,
    required this.distance,
    required this.summary,
  });

  final List<dynamic> viaWaypoints;
  final List<Admin> admins;
  final double weight;
  final double duration;
  final List<Step> steps;
  final double distance;
  final String summary;

  factory Leg.fromJson(String str) => Leg.fromMap(json.decode(str));

  factory Leg.fromMap(Map<String, dynamic> json) => Leg(
        viaWaypoints: List<dynamic>.from(json["via_waypoints"].map((x) => x)),
        admins: List<Admin>.from(json["admins"].map((x) => Admin.fromMap(x))),
        weight: json["weight"].toDouble(),
        duration: json["duration"].toDouble(),
        steps: List<Step>.from(json["steps"].map((x) => Step.fromMap(x))),
        distance: json["distance"].toDouble(),
        summary: json["summary"],
      );
}

class Admin {
  Admin({
    required this.iso31661Alpha3,
    required this.iso31661,
  });

  final String iso31661Alpha3;
  final String iso31661;

  factory Admin.fromJson(String str) => Admin.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Admin.fromMap(Map<String, dynamic> json) => Admin(
        iso31661Alpha3: json["iso_3166_1_alpha3"],
        iso31661: json["iso_3166_1"],
      );

  Map<String, dynamic> toMap() => {
        "iso_3166_1_alpha3": iso31661Alpha3,
        "iso_3166_1": iso31661,
      };
}

class Step {
  Step({
    required this.intersections,
    required this.maneuver,
    required this.name,
    required this.duration,
    required this.distance,
    required this.weight,
    required this.geometry,
    required this.ref,
    required this.rotaryName,
  });

  final List<Intersection> intersections;
  final Maneuver maneuver;
  final String name;
  final double duration;
  final double distance;
  final double weight;
  final String geometry;
  final String? ref;
  final String? rotaryName;

  factory Step.fromJson(String str) => Step.fromMap(json.decode(str));

  factory Step.fromMap(Map<String, dynamic> json) => Step(
        intersections: List<Intersection>.from(
            json["intersections"].map((x) => Intersection.fromMap(x))),
        maneuver: Maneuver.fromMap(json["maneuver"]),
        name: json["name"],
        duration: json["duration"].toDouble(),
        distance: json["distance"].toDouble(),
        weight: json["weight"].toDouble(),
        geometry: json["geometry"],
        ref: json["ref"] == null ? null : json["ref"],
        rotaryName: json["rotary_name"] == null ? null : json["rotary_name"],
      );
}

class Intersection {
  Intersection({
    required this.bearings,
    required this.entry,
    this.isUrban,
    required this.adminIndex,
    required this.out,
    required this.geometryIndex,
    required this.location,
    this.intersectionIn,
    this.duration,
    this.turnWeight,
    this.turnDuration,
    this.weight,
    this.trafficSignal,
    this.railwayCrossing,
  });

  final List<int> bearings;
  final List<bool> entry;
  final bool? isUrban;
  final int adminIndex;
  final int? out;
  final int geometryIndex;
  final List<double> location;
  final int? intersectionIn;
  final double? duration;
  final double? turnWeight;
  final double? turnDuration;
  final double? weight;
  final bool? trafficSignal;
  final bool? railwayCrossing;

  factory Intersection.fromJson(String str) =>
      Intersection.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Intersection.fromMap(Map<String, dynamic> json) => Intersection(
        bearings: List<int>.from(json["bearings"].map((x) => x)),
        entry: List<bool>.from(json["entry"].map((x) => x)),
        isUrban: json["is_urban"] == null ? null : json["is_urban"],
        adminIndex: json["admin_index"],
        out: json["out"] == null ? null : json["out"],
        geometryIndex: json["geometry_index"],
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
        intersectionIn: json["in"] == null ? null : json["in"],
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        turnWeight:
            json["turn_weight"] == null ? null : json["turn_weight"].toDouble(),
        turnDuration: json["turn_duration"] == null
            ? null
            : json["turn_duration"].toDouble(),
        weight: json["weight"] == null ? null : json["weight"].toDouble(),
        trafficSignal:
            json["traffic_signal"] == null ? null : json["traffic_signal"],
        railwayCrossing:
            json["railway_crossing"] == null ? null : json["railway_crossing"],
      );

  Map<String, dynamic> toMap() => {
        "bearings": List<dynamic>.from(bearings.map((x) => x)),
        "entry": List<dynamic>.from(entry.map((x) => x)),
        "is_urban": isUrban == null ? null : isUrban,
        "admin_index": adminIndex,
        "out": out == null ? null : out,
        "geometry_index": geometryIndex,
        "location": List<dynamic>.from(location.map((x) => x)),
        "in": intersectionIn == null ? null : intersectionIn,
        "duration": duration == null ? null : duration,
        "turn_weight": turnWeight == null ? null : turnWeight,
        "turn_duration": turnDuration == null ? null : turnDuration,
        "weight": weight == null ? null : weight,
        "traffic_signal": trafficSignal == null ? null : trafficSignal,
        "railway_crossing": railwayCrossing == null ? null : railwayCrossing,
      };
}

class Maneuver {
  Maneuver({
    required this.type,
    required this.instruction,
    required this.bearingAfter,
    required this.bearingBefore,
    required this.location,
    required this.exit,
  });

  final String type;
  final String instruction;
  final int bearingAfter;
  final int bearingBefore;
  final List<double> location;
  final int? exit;

  factory Maneuver.fromJson(String str) => Maneuver.fromMap(json.decode(str));

  factory Maneuver.fromMap(Map<String, dynamic> json) => Maneuver(
        type: json["type"],
        instruction: json["instruction"],
        bearingAfter: json["bearing_after"],
        bearingBefore: json["bearing_before"],
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
        exit: json["exit"] == null ? null : json["exit"],
      );
}

class Waypoint {
  Waypoint({
    required this.distance,
    required this.name,
    required this.location,
  });

  final double distance;
  final String name;
  final List<double> location;

  factory Waypoint.fromJson(String str) => Waypoint.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Waypoint.fromMap(Map<String, dynamic> json) => Waypoint(
        distance: json["distance"].toDouble(),
        name: json["name"],
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toMap() => {
        "distance": distance,
        "name": name,
        "location": List<dynamic>.from(location.map((x) => x)),
      };
}
