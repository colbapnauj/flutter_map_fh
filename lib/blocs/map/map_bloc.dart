import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/helpers/helpers.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;

  StreamSubscription? _locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);
    on<OnStartFollowingUserEvent>(_onStartFollowingUser);
    on<OnStopFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(isFollowingUser: false)));

    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);
    on<OnToggleUserRoute>(
        (event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));

    _locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnownLocation != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }
      if (!state.isFollowingUser) return;
      if (locationState.lastKnownLocation == null) return;

      moveCamera(locationState.lastKnownLocation!);
    });

    on<DisplayPolylineEvent>(((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers))));
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;

    _mapController!.setMapStyle(jsonEncode(uberMapTheme));

    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));
    if (locationBloc.state.lastKnownLocation == null) return;

    moveCamera(locationBloc.state.lastKnownLocation!);
  }

  void _onPolylineNewPoint(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final Polyline myRoute = Polyline(
      polylineId: const PolylineId('myRoute'),
      color: Colors.green,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations,
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;

    emit(state.copyWith(polylines: currentPolylines));
  }

  Future<void> drawRoutePolyline(RouteDestination destination) async {
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      points: destination.points,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    int tripDurations = (destination.duration ~/ 60);

    // Custom Marker
    // final customStartMarker = await getAssetImageMarker();
    final customStartMarker = await getStartCustomMarker(
      tripDurations,
      'Mi Ubicación',
    );

    // final customEndMarker = await getNetworkImageMarker();
    final customEndMarker = await getEndCustomMarker(
      kms.toInt(),
      destination.endPlace.text,
    );

    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: destination.points.first,
      icon: customStartMarker,
      anchor: const Offset(0.06, 0.95),
      // infoWindow: InfoWindow(
      //   title: 'Inicio',
      //   snippet: 'Kms: $kms, durations: $tripDurations min',
      // ),
    );

    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,
      icon: customEndMarker,
      // infoWindow: InfoWindow(
      //     title: destination.endPlace.text,
      //     snippet: destination.endPlace.placeName,
      //     onTap: () {}),
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;

    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;

    add(DisplayPolylineEvent(currentPolylines, currentMarkers));

    await Future.delayed(const Duration(milliseconds: 300));

    _mapController?.showMarkerInfoWindow(const MarkerId('start'));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    _locationStateSubscription?.cancel();
    return super.close();
  }
}
