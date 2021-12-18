import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:misiontic/pantallas/mapas.dart';
import 'package:misiontic/pantallas/listadoNegocios.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class mapas extends StatefulWidget {
  final datosNegocios negocio;
  mapas({required this.negocio});
  @override
  _mapasState createState() => _mapasState(negocio: negocio);
}

class _mapasState extends State<mapas> {
  datosNegocios negocio;
  _mapasState({required this.negocio});

  @override
  Widget build(BuildContext context) {
    final posicion = CameraPosition(
        target: LatLng(negocio.geolocalizacion.latitude, negocio.geolocalizacion.longitude),
        zoom: 15
    );
    final Set<Marker> marcador = Set();
    marcador.add(
      Marker(
        markerId: MarkerId(negocio.direccion),
        position: LatLng(negocio.geolocalizacion.latitude, negocio.geolocalizacion.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
            title: negocio.nombre,
            snippet: negocio.direccion
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Geolocalización de " + negocio.nombre),
      ),
      body: GoogleMap(
        initialCameraPosition: posicion,
        scrollGesturesEnabled: true,//mover el mapa
        zoomControlsEnabled: false,//botones de zoom
        zoomGesturesEnabled: false,//zoom con tactil
        markers: marcador,
      ),
    );
  }
}