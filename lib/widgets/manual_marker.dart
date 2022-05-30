import 'package:flutter/material.dart';
import 'dart:io';
import 'package:animate_do/animate_do.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/helpers/helpers.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => state.displayManualMarker
            ? const _ManualMarkerBody()
            : const SizedBox.shrink());
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            const Positioned(
              top: 50,
              left: 40,
              child: _BtnBack(),
            ),
            Center(
              child: Transform.translate(
                offset: const Offset(0, -22),
                child: BounceInDown(
                  from: 200,
                  child: const Icon(
                    Icons.location_on_rounded,
                    size: 60,
                  ),
                ),
              ),
            ),
            // Boton Confirmar
            Positioned(
              bottom: 70,
              left: 40,
              child: FadeInUp(
                duration: const Duration(milliseconds: 250),
                child: MaterialButton(
                  minWidth: size.width - 120,
                  child: const Text(
                    'Confirmar destino',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                  color: Colors.green,
                  elevation: 5,
                  shape: const StadiumBorder(),
                  onPressed: () async {
                    final start = locationBloc.state.lastKnownLocation;
                    if (start == null) return;

                    final end = mapBloc.mapCenter;
                    if (end == null) return;

                    showLoadingMessage(context);

                    final destination =
                        await searchBloc.getCoorsStartToEnd(start, end);

                    await mapBloc.drawRoutePolyline(destination);

                    searchBloc.add(OnDeactivateManualMarkerEvent());
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ));
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 250),
      child: CircleAvatar(
          maxRadius: 30,
          backgroundColor: Colors.white,
          child: IconButton(
              onPressed: () {
                final searchBloc = BlocProvider.of<SearchBloc>(context);
                searchBloc.add(OnDeactivateManualMarkerEvent());
              },
              icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                color: Colors.black,
              ))),
    );
  }
}
