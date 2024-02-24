import 'package:map_location_picker/map_location_picker.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';

class PlacePicker extends StatefulWidget {
  const PlacePicker({super.key});

  @override
  State<PlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  @override
  Widget build(BuildContext context) {
    return GoogleMapLocationPicker(
      apiKey: 'AIzaSyBE3guJiWDX0AVN4upOOChc5BmJIAwryZc',
      currentLatLng: const LatLng(29.146727, 76.464895),
      suggestionsBuilder: null,
      listBuilder: null,
      onNext: (GeocodingResult? result) {
        if (result != null) {
          final location = result.geometry.location;
          Get.back(result: '${location.lat}, ${location.lng}');
        }
      },
      onSuggestionSelected: (p0) {},
    );
  }
}
