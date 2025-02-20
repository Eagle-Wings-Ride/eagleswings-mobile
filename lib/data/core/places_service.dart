import 'package:dio/dio.dart';

import '../models/location_onboarding_data.dart';
import '../models/place_prediction.dart';

class PlacesService {
  final Dio _dio;
  final String _apiKey;

  PlacesService({
    required String apiKey,
    Dio? dio,
  })  : _apiKey = apiKey,
        _dio = dio ?? Dio();

  Future<List<Placeprediction>> searchPlaces(
      String query, String sessionToken) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': _apiKey,
          // 'types': 'address',
          'types': 'geocode|establishment', // Allows named places like schools
          // Add your country restriction if needed
          'components': 'country:ca',
          'sessiontoken': sessionToken, // Pass the session token
        },
      );

      if (response.data['status'] == 'OK') {
        return (response.data['predictions'] as List)
            .map((prediction) => Placeprediction.fromJson(prediction))
            .toList();
      }
      return [];

      // throw Exception('Place search failed: ${response.data['error_message']}');
    } catch (e) {
      throw Exception('Failed to search places: $e');
    }
  }

  Future<LocationOnboardingData> getPlaceDetails(
      String placeId, String sessionToken) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': _apiKey,
          'fields': 'name,address_component,geometry,formatted_address,types',
          'sessiontoken': sessionToken, // Use the same session token
          // 'fields': 'address_component,geometry,formatted_address'
        },
      );

      print('Place Details Response: ${response.data}'); // Debug print

      if (response.data['status'] == 'OK') {
        final result = response.data['result'];

        final locationData = LocationOnboardingData(
          address: result['formatted_address'],
          city: _extractAddressComponent(
              result['address_components'], 'locality'),
          state: _extractAddressComponent(
              result['address_components'], 'administrative_area_level_1'),
          country:
              _extractAddressComponent(result['address_components'], 'country'),
          postalCode: _extractAddressComponent(
              result['address_components'], 'postal_code'),
          latitude: result['geometry']['location']['lat'],
          longitude: result['geometry']['location']['lng'],
        );

        print('Parsed Location Data: $locationData'); // Debug print
        return locationData;
      }
      return LocationOnboardingData(
        address: '',
        city: '',
        state: '',
        country: '',
        postalCode: '',
        latitude: 0.0,
        longitude: 0.0,
      );

      // throw Exception(
      //     'Place details failed: ${response.data['error_message']}');
    } catch (e) {
      print('Error in getPlaceDetails: $e'); // Debug print
      throw Exception('Failed to get place details: $e');
    }
  }

  String? _extractAddressComponent(List components, String type) {
    final component = components.firstWhere(
      (comp) => (comp['types'] as List).contains(type),
      orElse: () => null,
    );
    return component?['long_name'];
  }
}
