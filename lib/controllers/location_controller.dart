import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Handles GPS Location and Reverse Geocoding using OpenStreetMap
class LocationController extends GetxController {
  /// The reactive string to display on the Home Screen
  var currentLocation = 'Locating...'.obs;

  @override
  void onInit() {
    super.onInit();
    _determinePosition();
  }

  /// Request permissions and get current position
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      currentLocation.value = 'Location Services Disabled';
      return;
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        currentLocation.value = 'Location Denied';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      currentLocation.value = 'Location Permanently Denied';
      return;
    }

    try {
      // Get exact GPS coordinates
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocode to get city name
      await _getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Error getting location: $e');
      currentLocation.value = 'Bilzen, Tanjungbalai'; // Fallback
    }
  }

  /// Call OpenStreetMap Nominatim API to convert coordinates to an address
  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=10&addressdetails=1');

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'CoffeeShopApp/1.0 (contact@coffeeshop.com)'
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];
        
        // Extract city or town
        String city = address['city'] ?? 
                     address['town'] ?? 
                     address['village'] ?? 
                     address['county'] ?? 
                     'Unknown City';
                     
        String state = address['state'] ?? address['country'] ?? '';

        if (state.isNotEmpty) {
          currentLocation.value = '$city, $state';
        } else {
          currentLocation.value = city;
        }
      } else {
        currentLocation.value = 'Bilzen, Tanjungbalai'; // Fallback
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
      currentLocation.value = 'Bilzen, Tanjungbalai'; // Fallback
    }
  }
}
