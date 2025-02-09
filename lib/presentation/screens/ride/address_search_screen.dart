import 'package:eaglerides/config/map_api_key.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/debouncer.dart';
import '../../../data/core/places_service.dart';
import '../../../data/models/place_prediction.dart';
import '../../../styles/styles.dart';
import 'widget/custom_loader.dart';

class AddressSearchScreen extends StatefulWidget {
  final TextEditingController searchController;
  // final ValueChanged onLocationSelected;
  const AddressSearchScreen({
    super.key,
    required this.searchController,
    // required this.onLocationSelected,
  });

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  final PlacesService _placesService = PlacesService(apiKey: apiKey);
  final _debouncer = Debouncer(milliseconds: 500);
  List<Placeprediction> _predictions = [];
  bool _isLoading = false;

  Future<void> _searchPlaces(String query) async {
    if (query.length < 3) return;
    setState(() => _isLoading = true);

    try {
      final predictions = await _placesService.searchPlaces(query);
      ;
      setState(() => _predictions = predictions);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching for places: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectPlace(Placeprediction prediction) async {
    setState(() => _isLoading = true);

    try {
      final placeDetails =
          await _placesService.getPlaceDetails(prediction.placeId);

      Navigator.pop(context, placeDetails);

      print('Place Details: $placeDetails'); // Debug print

      // widget.onLocationSelected(placeDetails);
      widget.searchController.text = placeDetails.address ?? '';
      setState(() => _predictions = []);
    } catch (e) {
      print('Error in _selectPlace: $e'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error getting place details'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search for your address"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            TextFormField(
              controller: widget.searchController,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: -.5,
              ),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -.5,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: Colors.black,
                ),
                suffixIcon: widget.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          widget.searchController.clear();
                          setState(() => _predictions = []);
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: greyColor, width: 0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: greyColor, width: 0.5),
                ),
                focusedBorder: (OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                )).copyWith(
                  borderSide: BorderSide(color: backgroundColor, width: 0.5),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() => _predictions = []);
                  return;
                }

                _debouncer.run(() {
                  if (value.length > 2) {
                    _searchPlaces(value);
                  }
                });
              },
            ),
            const SizedBox(height: 8),
            // Row(
            //   children: [
            //     Icon(
            //       Icons.near_me_rounded,
            //       color: hintColor,
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     Text(
            //       'Use my current location',
            //       style: TextStyle(
            //         fontSize: 12,
            //         fontWeight: FontWeight.w500,
            //         letterSpacing: -.5,
            //         color: hintColor,
            //         decoration: TextDecoration.underline,
            //       ),
            //     ),
            //   ],
            // ),
            // ElevatedButton.icon(
            //   onPressed: _useCurrentLocation,
            //   icon: const Icon(Icons.my_location),
            //   label: const Text("Use Current Location"),
            // ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CustomLoader())
                  : ListView.separated(
                      itemCount: _predictions.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        child: Divider(
                          color: hintColor,
                        ),
                      ), // Adds a line between items
                      itemBuilder: (context, index) {
                        final prediction = _predictions[index];
                        return ListTile(
                          minTileHeight: 0,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: const Icon(Icons.domain_outlined,
                              color: Colors.black), // Leading icon
                          title: Text(
                            prediction.mainText,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -.5,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            prediction.secondaryText,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -.5,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () => _selectPlace(prediction),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
