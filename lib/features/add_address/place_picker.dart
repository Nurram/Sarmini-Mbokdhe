import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';

class PlacePicker extends StatefulWidget {
  const PlacePicker({super.key});

  @override
  State<PlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  LatLng currentLatLng = const LatLng(37.42796133580664, -122.085749655962);
  LatLng? selectedLatLng;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final List<Marker> _markers = <Marker>[
    const Marker(
      markerId: MarkerId('SomeId'),
      position: LatLng(37.42796133580664, -122.085749655962),
      infoWindow: InfoWindow(title: 'Lokasi dipilih'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: currentLatLng),
            markers: Set<Marker>.of(_markers),
            onMapCreated: (controller) {
              _controller.complete(controller);
              _getCurrentLatLng();
            },
            onTap: (argument) {
              selectedLatLng = LatLng(argument.latitude, argument.longitude);
              _markers[0] = Marker(
                markerId: const MarkerId('SomeId'),
                position: selectedLatLng!,
                infoWindow: const InfoWindow(title: 'Lokasi dipilih'),
              );

              setState(() {});
            },
          ),
        ),
        Visibility(
          visible: selectedLatLng != null,
          child: CustomElevatedButton(
            text: 'Pilih',
            borderRadius: 0,
            bgColor: CustomColors.primaryColor,
            onPressed: () {
              Get.back(result: selectedLatLng);
            },
          ),
        )
      ],
    );
  }

  _getCurrentLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentLatLng = LatLng(position.latitude, position.longitude);
    _markers[0] = Marker(
      markerId: const MarkerId('SomeId'),
      position: currentLatLng,
      infoWindow: const InfoWindow(title: 'Lokasi dipilih'),
    );
    selectedLatLng = currentLatLng;

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLatLng, zoom: 19),
      ),
    );

    setState(() {});
  }
}
