import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/delegates/delegates.dart';
import 'package:maps_app/helpers/helpers.dart';
import 'package:maps_app/models/models.dart';

import '../blocs/blocs.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) => state.displayManualMarker
          ? const SizedBox.shrink()
          : ElasticInDown(child: const _SearchBarBody()),
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({Key? key}) : super(key: key);

  void onSearchResults(BuildContext context, SearchResult result) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    if (result.manual) {
      searchBloc.add(OnActivateManualMarkerEvent());
      return;
    }

    if (result.position != null) {
      final start = locationBloc.state.lastKnownLocation;
      if (start == null) return;

      final end = mapBloc.mapCenter;
      if (end == null) return;

      showLoadingMessage(context);

      final destination = await searchBloc.getCoorsStartToEnd(locationBloc.state.lastKnownLocation!, mapBloc.mapCenter!);

      await mapBloc.drawRoutePolyline(destination);

      searchBloc.add(OnDeactivateManualMarkerEvent());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context).state;
    return SafeArea(
      child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: GestureDetector(
              onTap: () async {
                final result = await showSearch(
                    context: context,
                    delegate: SearchDestinationDelegate(
                        proximity: locationBloc.lastKnownLocation!,
                        hintText: 'search term'));

                if (result == null) return;

                onSearchResults(context, result);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                child: const Text('Dónde quieres ir?',
                    style: TextStyle(color: Colors.black87)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(2, 10))
                    ]),
              ))),
    );
  }
}
