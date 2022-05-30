// To parse this JSON data, do
//
//     final placesResponse = placesResponseFromMap(jsonString);

import 'dart:convert';

class PlacesResponse {
    PlacesResponse({
        required this.type,
        required this.features,
        required this.attribution,
    });

    final String type;
    final List<Feature> features;
    final String attribution;

    factory PlacesResponse.fromJson(String str) => PlacesResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PlacesResponse.fromMap(Map<String, dynamic> json) => PlacesResponse(
        type: json['type'],
        features: List<Feature>.from(json['features'].map((x) => Feature.fromMap(x))),
        attribution: json['attribution'],
    );

    Map<String, dynamic> toMap() => {
        'type': type,
        'features': List<dynamic>.from(features.map((x) => x.toMap())),
        'attribution': attribution,
    };
}

class Feature {
    Feature({
        required this.id,
        required this.type,
        required this.placeType,
        required this.properties,
        required this.text,
        required this.placeName,
        this.bbox,
        required this.center,
        required this.geometry,
        required this.context,
    });

    final String id;
    final String type;
    final List<String> placeType;
    final Properties properties;
    final String text;
    final String placeName;
    final List<double>? bbox;
    final List<double> center;
    final Geometry geometry;
    final List<Context> context;

    factory Feature.fromJson(String str) => Feature.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        id: json['id'],
        type: json['type'],
        placeType: List<String>.from(json['place_type'].map((x) => x)),
        properties: Properties.fromMap(json['properties']),
        text: json['text'],
        placeName: json['place_name'],
        bbox: json['bbox'] == null ? null : List<double>.from(json['bbox'].map((x) => x.toDouble())),
        center: List<double>.from(json['center'].map((x) => x.toDouble())),
        geometry: Geometry.fromMap(json['geometry']),
        context: List<Context>.from(json['context'].map((x) => Context.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'place_type': List<dynamic>.from(placeType.map((x) => x)),
        'properties': properties.toMap(),
        'text': text,
        'place_name': placeName,
        'bbox': bbox == null ? null : List<dynamic>.from(bbox!.map((x) => x)),
        'center': List<dynamic>.from(center.map((x) => x)),
        'geometry': geometry.toMap(),
        'context': List<dynamic>.from(context.map((x) => x.toMap())),
    };

    @override
    String toString() {
        return 'Feature: $text';
    }
}

class Context {
    Context({
        required this.id,
        this.shortCode,
        this.wikidata,
        required this.text,
    });

    final String id;
    final String? shortCode;
    final String? wikidata;
    final String text;

    factory Context.fromJson(String str) => Context.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Context.fromMap(Map<String, dynamic> json) => Context(
        id: json['id'],
        shortCode: json['short_code'],
        wikidata: json['wikidata'],
        text: json['text'],
    );

    Map<String, dynamic> toMap() => {
        'id': id,
        'short_code': shortCode,
        'wikidata': wikidata,
        'text': text,
    };
}

class Geometry {
    Geometry({
        required this.type,
        required this.coordinates,
    });

    final String type;
    final List<double> coordinates;

    factory Geometry.fromJson(String str) => Geometry.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Geometry.fromMap(Map<String, dynamic> json) => Geometry(
        type: json['type'],
        coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );

    Map<String, dynamic> toMap() => {
        'type': type,
        'coordinates': List<dynamic>.from(coordinates.map((x) => x)),
    };
}

class Properties {
    Properties({
        this.wikidata,
        this.accuracy,
    });

    final String? wikidata;
    final String? accuracy;

    factory Properties.fromJson(String str) => Properties.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Properties.fromMap(Map<String, dynamic> json) => Properties(
        wikidata: json['wikidata'],
        accuracy: json['accuracy'],
    );

    Map<String, dynamic> toMap() => {
        'wikidata': wikidata,
        'accuracy': accuracy,
    };
}
