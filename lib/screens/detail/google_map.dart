import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';

class GoogleMapPage extends StatefulWidget {
  final Function(String) onFinish; // Callback to pass the selected address

  const GoogleMapPage({super.key, required this.onFinish});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late GoogleMapController _mapController;
  final LatLng _currentLocation =
      const LatLng(10.8231, 106.6297); // Ho Chi Minh City
  final TextEditingController _addressController = TextEditingController();
  final Set<Marker> _markers = {};
  List<dynamic> _suggestions = []; // To hold the search suggestions
  final FocusNode _focusNode = FocusNode(); // FocusNode for TextField
  Timer? _debounce; // Timer for debounce

  @override
  void initState() {
    super.initState();
    // Auto-focus the TextField when the screen opens
    Future.delayed(Duration.zero, () {
      _focusNode.requestFocus();
    });
  }

  // Updated fetch suggestions function with debounce
  Future<void> _getSuggestions(String query) async {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 200), () async {
      if (query.isEmpty) {
        setState(() {
          _suggestions.clear();
        });
        return;
      }

      final String url =
          'https://nominatim.openstreetmap.org/search?format=json&q=$query&limit=5&countrycodes=VN';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            _suggestions = data;
          });
        }
      } catch (e) {
        print('Error fetching suggestions: $e');
      }
    });
  }

  // Get coordinates from the selected address
  Future<void> _getCoordinatesFromAddress(String address) async {
    final suggestion = _suggestions.firstWhere(
      (suggestion) => suggestion['display_name'] == address,
      orElse: () => null,
    );

    if (suggestion != null) {
      final lat = double.parse(suggestion['lat']);
      final lon = double.parse(suggestion['lon']);
      final LatLng destination = LatLng(lat, lon);

      setState(() {
        _markers.clear(); // Clear previous markers
        _markers.add(
          Marker(
            markerId: const MarkerId('receiver_address'),
            position: destination,
            infoWindow: const InfoWindow(title: 'Địa chỉ nhận hàng'),
          ),
        );
      });

      _mapController.animateCamera(CameraUpdate.newLatLngZoom(destination, 18));

      // Update the address in the TextField
      _addressController.text = suggestion['display_name'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy địa chỉ')),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel debounce timer when disposing
    _addressController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        title: const CustomText(text: 'ĐỊA CHỈ NHẬN HÀNG', size: 20),
        centerTitle: false,
        actions: [
          // Button with Text first and Check icon after
          TextButton(
            onPressed: () {
              final address = _addressController.text; // Get address
              if (address.isNotEmpty) {
                widget.onFinish(address); // Pass address back
                Navigator.pop(context); // Close the GoogleMapPage
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Xin hãy chọn địa chỉ'),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent, // Green background
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'Xác Nhận',
                  style: TextStyle(
                    color: Colors.white, // White text
                    fontSize: 16, // Font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
                SizedBox(width: 8), // Space between text and icon
                Icon(
                  Icons.check,
                  color: Colors.white, // White check icon
                ),
              ],
            ),
          ),
        ],
        automaticallyImplyLeading: false, // Explicitly prevent back button
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF20B6E8), Color(0xFF16B2A5)],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _markers,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.teal,
                            controller: _addressController,
                            focusNode: _focusNode,
                            decoration: const InputDecoration(
                              labelText: 'Nhập địa chỉ',
                              floatingLabelStyle: TextStyle(color: Colors.teal),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                            ),
                            onChanged: (text) {
                              _getSuggestions(text);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _addressController.clear();
                            setState(() {
                              _suggestions.clear();
                            });
                          },
                        ),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _suggestions.isNotEmpty
                          ? Container(
                              constraints: const BoxConstraints(maxHeight: 200),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _suggestions.length,
                                itemBuilder: (context, index) {
                                  final suggestion = _suggestions[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(suggestion['display_name']),
                                        onTap: () {
                                          _getCoordinatesFromAddress(
                                              suggestion['display_name']);
                                          setState(() {
                                            _suggestions.clear();
                                          });
                                        },
                                      ),
                                      if (index != _suggestions.length - 1)
                                        const Divider(),
                                    ],
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
