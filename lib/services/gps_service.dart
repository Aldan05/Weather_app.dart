import 'package:geolocator/geolocator.dart';

class GPSService {
  Future<Position> getPosition() async {
    bool permission = await Geolocator.isLocationServiceEnabled();
    if (!permission) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission request = await Geolocator.requestPermission();
    if (request == LocationPermission.denied) {
      request = await Geolocator.requestPermission();
    }
    
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
