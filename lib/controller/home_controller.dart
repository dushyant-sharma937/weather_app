import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/api_services.dart';

class HomeController extends GetxController {
  RxString longitude = ''.obs;
  RxString latitude = ''.obs;
  RxString mainValue = ''.obs;
  RxBool isLoading = false.obs;

  RxString temperature = ''.obs;
  RxString tempMin = ''.obs;
  RxString tempMax = ''.obs;
  RxString pressure = ''.obs;
  RxString humidity = ''.obs;
  RxString feelsLike = ''.obs;
  RxString visibility = ''.obs;
  RxString country = ''.obs;
  RxString name = ''.obs;
  RxString windSpeed = ''.obs;
  RxString base = ''.obs;
  RxString weatherMain = ''.obs;
  RxString weatherDesc = ''.obs;
  RxString weatherIcon = ''.obs;

  RxString weatherIconUrl =
      'https://openweathermap.org/img/wn/{icon}@2x.png'.obs;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  Future<void> getCurrentPosition() async {
    isLoading.value = true;
    final hasPermission = await handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    // store position here
    longitude.value = position.longitude.toString();
    latitude.value = position.latitude.toString();
    isLoading.value = false;
  }

  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      mainValue.value = _kLocationServicesDisabledMessage;

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        mainValue.value = _kPermissionDeniedMessage;
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      mainValue.value = _kPermissionDeniedForeverMessage;
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    mainValue.value = _kPermissionGrantedMessage;
    return true;
  }

  void openAppSettings() async {
    final opened = await _geolocatorPlatform.openAppSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Application Settings.';
    } else {
      displayValue = 'Error opening Application Settings.';
    }

    mainValue.value = displayValue;
  }

  void openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Location Settings';
    } else {
      displayValue = 'Error opening Location Settings';
    }

    mainValue.value = displayValue;
  }

  Future<bool> fetchData() async {
    isLoading.value = true;
    await getCurrentPosition();
    var data = await ApiServices()
        .fetchData(double.parse(latitude.value), double.parse(longitude.value));
    if (data['statusCode'] != 200) {
      isLoading.value = false;
      return false;
    } else {
      weatherMain.value = data['weather'][0]['main'].toString();
      weatherDesc.value = data['weather'][0]['description'].toString();
      base.value = data['base'].toString();
      temperature.value = (data['main']['temp'] - 273.15).toStringAsFixed(1);
      feelsLike.value =
          (data['main']['feels_like'] - 273.15).toStringAsFixed(1);
      tempMin.value = (data['main']['temp_min'] - 273.15).toStringAsFixed(0);
      tempMax.value = (data['main']['temp_max'] - 273.15).toStringAsFixed(0);
      pressure.value = data['main']['pressure'].toStringAsFixed(0);
      humidity.value = data['main']['humidity'].toStringAsFixed(0);
      visibility.value = data['visibility'].toStringAsFixed(0);
      windSpeed.value = (data['wind']['speed'] * 3.6).toStringAsFixed(2);
      country.value = data['sys']['country'].toString();
      name.value = data['name'].toString();
      weatherIcon.value = data['weather'][0]['icon'].toString();
      weatherIconUrl.value =
          weatherIconUrl.value.replaceFirst('{icon}', weatherIcon.value);
      isLoading.value = false;
      return true;
    }
  }
}
