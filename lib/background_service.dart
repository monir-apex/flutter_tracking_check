import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test_application/store_data.dart';



Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onBackground: (ServiceInstance service) async{
        service.on("OnBackGround").listen((event) {
          print("Hello this is background");
        });
        print("Hello");
        return true;
      },
      // onForeground:,
    ),
  );
  // service.startService();
  // service.on("OnBackground").listen((event) {
  //   print("Hello bro");
  // });
}



Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  double givenLatitude = 23.804302; // Example latitude
  double givenLongitude = 90.410762;

  // 23.804302, 90.410762
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      TimeOfDay now = TimeOfDay.now();
      if(now.minute == 32){
        Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        double distanceInMeters = Geolocator.distanceBetween(
            currentPosition.latitude, currentPosition.longitude,
            givenLatitude, givenLongitude);

        StoreDataLocally.saveDataList([
          UserInfo(
              name: "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
              lat: currentPosition.latitude.toString(),
              lng: currentPosition.longitude.toString()
          )
        ]);
        print("Hello minute ${now.minute}");
      }else if(now.minute == 44){
        print("Close now");
        timer.cancel();
      }
    }
  });
}


class UserInfo {
  String name;
  String lat;
  String lng;

  UserInfo({
    required this.name,
    required this.lat,
    required this.lng,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    name: json["name"],
    lat: json["lat"],
    lng: json["lng"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "lat": lat,
    "lng": lng,
  };
}

