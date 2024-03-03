import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationScreen extends StatefulWidget {

  String name;
  String caption;
  double long;
  double lat;

  LocationScreen({super.key, required this.name, required this.caption, required this.long, required this.lat});

  @override
  State<StatefulWidget> createState() => _LocationScreen();

}

class _LocationScreen extends State<LocationScreen> {
  final Set<Marker> markers = {};
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _setAddress(widget.long, widget.lat, (address) {
      final marker = Marker(
        markerId: const MarkerId("story"),
        position: LatLng(widget.lat, widget.long),
        infoWindow: InfoWindow(
            title: widget.name,
            snippet: address
        ),
        onTap: () {
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(widget.lat, widget.long), 18),
          );
        },
      );
      markers.add(marker);
    });
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text(
          'Location',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        shape: const Border(
            bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      body: GoogleMap(
        markers: markers,
        initialCameraPosition: CameraPosition(
          zoom: 15,
          target: LatLng(widget.lat, widget.long),
        ),
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    ));
  }

  void _setAddress(double long, double lat, Function(String) callback) async {
    final info = await geo.placemarkFromCoordinates(lat, long);
    final place = info[0];
    final address = '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    callback(address);
  }

}