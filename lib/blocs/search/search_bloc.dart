import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:maps_app/models/models.dart';
import 'package:maps_app/services/services.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required this.trafficService,
  }) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>((event, emit) {
      emit(state.copyWith(displayManualMarker: true));
    });

    on<OnDeactivateManualMarkerEvent>((event, emit) {
      emit(state.copyWith(displayManualMarker: false));
    });

    on<OnNewPlacesFoundEvent>(
        (event, emit) => emit(state.copyWith(places: event.places)));

    on<OnNewPlaceSelectedEvent>(_onNewPlaceSelectedEvent);
  }
  final TrafficService trafficService;

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);

    final geometry = trafficResponse.routes[0].geometry;
    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;

    /// Decode the polyline
    final points = decodePolyline(geometry, accuracyExponent: 5);
    final latLngList = points
        .map((coor) => LatLng(coor[0].toDouble(), coor[1].toDouble()))
        .toList();

    return RouteDestination(
      points: latLngList,
      duration: duration,
      distance: distance,
    );
  }

  Future getPlacesByQuery(LatLng proximity, String query) async {
    final newPlaces = await trafficService.getResultByQuery(proximity, query);

    add(OnNewPlacesFoundEvent(newPlaces));
  }

  void _onNewPlaceSelectedEvent(event, emit) {
    final history = [];
    for (int i = 0; i < state.history.length || i < 10; i++) {
      history.add(state.history[i]);
    }
    emit(state.copyWith(history: [event.place, ...history]));
  }
}
