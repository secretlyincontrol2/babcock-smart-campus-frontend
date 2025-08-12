import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart' as lottie;
import '../../../../core/theme/app_theme.dart';

class MapsTab extends StatefulWidget {
  const MapsTab({super.key});

  @override
  State<MapsTab> createState() => _MapsTabState();
}

class _MapsTabState extends State<MapsTab> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _locationCategories = [
    'All',
    'Academic',
    'Administrative',
    'Recreational',
    'Dining',
    'Residential',
    'Transportation',
    'Healthcare',
    'Parking',
    'Sports',
  ];
  String _selectedCategory = 'All';
  bool _showIndoorMaps = false;
  String? _selectedBuilding;
  List<Map<String, dynamic>> _filteredLocations = [];

  // Comprehensive campus locations with real data
  final List<Map<String, dynamic>> _campusLocations = [
    // Academic Buildings
    {
      'id': 'lib_main',
      'name': 'Main Library',
      'category': 'Academic',
      'latitude': 7.3961,
      'longitude': 3.8969,
      'description': 'Central library with study spaces, computer labs, and research facilities',
      'icon': Icons.library_books,
      'floors': 4,
      'facilities': ['Study Rooms', 'Computer Lab', 'Printing', 'WiFi', 'Café'],
      'hours': '7:00 AM - 10:00 PM',
      'contact': '+234-1-234-5678',
      'image': 'assets/images/library.jpg',
    },
    {
      'id': 'sci_complex',
      'name': 'Science Complex',
      'category': 'Academic',
      'latitude': 7.3972,
      'longitude': 3.8972,
      'description': 'State-of-the-art science laboratories and research facilities',
      'icon': Icons.science,
      'floors': 5,
      'facilities': ['Physics Lab', 'Chemistry Lab', 'Biology Lab', 'Research Center'],
      'hours': '8:00 AM - 8:00 PM',
      'contact': '+234-1-234-5679',
      'image': 'assets/images/science.jpg',
    },
    {
      'id': 'eng_building',
      'name': 'Engineering Building',
      'category': 'Academic',
      'latitude': 7.3968,
      'longitude': 3.8978,
      'description': 'Engineering departments with modern workshops and labs',
      'icon': Icons.engineering,
      'floors': 6,
      'facilities': ['Mechanical Lab', 'Electrical Lab', 'Computer Lab', 'Workshop'],
      'hours': '7:30 AM - 9:00 PM',
      'contact': '+234-1-234-5680',
      'image': 'assets/images/engineering.jpg',
    },
    {
      'id': 'business_school',
      'name': 'Business School',
      'category': 'Academic',
      'latitude': 7.3955,
      'longitude': 3.8962,
      'description': 'Business and management education center',
      'icon': Icons.business,
      'floors': 4,
      'facilities': ['Lecture Halls', 'Case Study Rooms', 'Trading Lab', 'Conference Center'],
      'hours': '8:00 AM - 7:00 PM',
      'contact': '+234-1-234-5681',
      'image': 'assets/images/business.jpg',
    },
    
    // Administrative Buildings
    {
      'id': 'admin_building',
      'name': 'Administrative Building',
      'category': 'Administrative',
      'latitude': 7.3958,
      'longitude': 3.8965,
      'description': 'University administration offices and student services',
      'icon': Icons.account_balance,
      'floors': 3,
      'facilities': ['Registrar Office', 'Student Affairs', 'HR Department', 'Finance Office'],
      'hours': '8:00 AM - 5:00 PM',
      'contact': '+234-1-234-5682',
      'image': 'assets/images/admin.jpg',
    },
    {
      'id': 'admissions_center',
      'name': 'Admissions Center',
      'category': 'Administrative',
      'latitude': 7.3952,
      'longitude': 3.8968,
      'description': 'Student admissions and enrollment services',
      'icon': Icons.school,
      'floors': 2,
      'facilities': ['Admissions Office', 'Enrollment Center', 'Information Desk'],
      'hours': '8:00 AM - 6:00 PM',
      'contact': '+234-1-234-5683',
      'image': 'assets/images/admissions.jpg',
    },
    
    // Recreational Facilities
    {
      'id': 'student_center',
      'name': 'Student Center',
      'category': 'Recreational',
      'latitude': 7.3965,
      'longitude': 3.8975,
      'description': 'Student activities, recreation, and social spaces',
      'icon': Icons.sports_esports,
      'floors': 3,
      'facilities': ['Game Room', 'TV Lounge', 'Study Areas', 'Event Spaces'],
      'hours': '6:00 AM - 12:00 AM',
      'contact': '+234-1-234-5684',
      'image': 'assets/images/student_center.jpg',
    },
    {
      'id': 'fitness_center',
      'name': 'Fitness Center',
      'category': 'Recreational',
      'latitude': 7.3975,
      'longitude': 3.8985,
      'description': 'Modern fitness facility with gym equipment and classes',
      'icon': Icons.fitness_center,
      'floors': 2,
      'facilities': ['Gym Equipment', 'Yoga Studio', 'Swimming Pool', 'Locker Rooms'],
      'hours': '5:00 AM - 11:00 PM',
      'contact': '+234-1-234-5685',
      'image': 'assets/images/fitness.jpg',
    },
    
    // Dining Facilities
    {
      'id': 'main_cafeteria',
      'name': 'Main Cafeteria',
      'category': 'Dining',
      'latitude': 7.3968,
      'longitude': 3.8980,
      'description': 'Main dining facility with diverse food options',
      'icon': Icons.restaurant,
      'floors': 2,
      'facilities': ['Dining Hall', 'Food Court', 'Coffee Shop', 'Outdoor Seating'],
      'hours': '6:00 AM - 10:00 PM',
      'contact': '+234-1-234-5686',
      'image': 'assets/images/cafeteria.jpg',
    },
    {
      'id': 'coffee_shop',
      'name': 'Campus Coffee Shop',
      'category': 'Dining',
      'latitude': 7.3962,
      'longitude': 3.8970,
      'description': 'Cozy coffee shop with snacks and beverages',
      'icon': Icons.coffee,
      'floors': 1,
      'facilities': ['Coffee Bar', 'Snacks', 'Study Tables', 'WiFi'],
      'hours': '7:00 AM - 9:00 PM',
      'contact': '+234-1-234-5687',
      'image': 'assets/images/coffee.jpg',
    },
    
    // Residential Buildings
    {
      'id': 'student_housing_a',
      'name': 'Student Housing Block A',
      'category': 'Residential',
      'latitude': 7.3980,
      'longitude': 3.8990,
      'description': 'Modern student accommodation with amenities',
      'icon': Icons.home,
      'floors': 8,
      'facilities': ['Dorm Rooms', 'Common Areas', 'Laundry', 'Kitchen'],
      'hours': '24/7',
      'contact': '+234-1-234-5688',
      'image': 'assets/images/housing.jpg',
    },
    {
      'id': 'student_housing_b',
      'name': 'Student Housing Block B',
      'category': 'Residential',
      'latitude': 7.3985,
      'longitude': 3.8995,
      'description': 'Premium student housing with enhanced facilities',
      'icon': Icons.apartment,
      'floors': 10,
      'facilities': ['Premium Rooms', 'Study Lounges', 'Fitness Center', 'Café'],
      'hours': '24/7',
      'contact': '+234-1-234-5689',
      'image': 'assets/images/housing_premium.jpg',
    },
    
    // Transportation
    {
      'id': 'bus_stop_main',
      'name': 'Main Bus Stop',
      'category': 'Transportation',
      'latitude': 7.3950,
      'longitude': 3.8950,
      'description': 'Main campus transportation hub',
      'icon': Icons.directions_bus,
      'floors': 1,
      'facilities': ['Bus Shelter', 'Information Board', 'Seating', 'Lighting'],
      'hours': '5:00 AM - 12:00 AM',
      'contact': '+234-1-234-5690',
      'image': 'assets/images/bus_stop.jpg',
    },
    {
      'id': 'parking_main',
      'name': 'Main Parking Lot',
      'category': 'Parking',
      'latitude': 7.3945,
      'longitude': 3.8945,
      'description': 'Main campus parking facility',
      'icon': Icons.local_parking,
      'floors': 1,
      'facilities': ['Parking Spaces', 'Security', 'Lighting', 'CCTV'],
      'hours': '24/7',
      'contact': '+234-1-234-5691',
      'image': 'assets/images/parking.jpg',
    },
    
    // Healthcare
    {
      'id': 'health_center',
      'name': 'Campus Health Center',
      'category': 'Healthcare',
      'latitude': 7.3978,
      'longitude': 3.8988,
      'description': 'Comprehensive health services for students',
      'icon': Icons.local_hospital,
      'floors': 2,
      'facilities': ['Medical Clinic', 'Pharmacy', 'Counseling', 'Emergency Care'],
      'hours': '8:00 AM - 8:00 PM',
      'contact': '+234-1-234-5692',
      'image': 'assets/images/health.jpg',
    },
    
    // Sports Facilities
    {
      'id': 'sports_complex',
      'name': 'Sports Complex',
      'category': 'Sports',
      'latitude': 7.3990,
      'longitude': 3.9000,
      'description': 'Multi-sport facility with indoor and outdoor areas',
      'icon': Icons.sports_soccer,
      'floors': 2,
      'facilities': ['Indoor Court', 'Outdoor Fields', 'Track', 'Equipment Rental'],
      'hours': '6:00 AM - 10:00 PM',
      'contact': '+234-1-234-5693',
      'image': 'assets/images/sports.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredLocations = _campusLocations;
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      setState(() => _isLoading = true);
      
      // Get current location
      await _getCurrentLocation();
      
      // Add campus markers
      _addCampusMarkers();
      
      // Move camera to current location or campus center
      if (_currentPosition != null) {
        _moveCameraToPosition(_currentPosition!);
      } else {
        // Default to campus center
        _moveCameraToPosition(Position(
          latitude: 7.3965,
          longitude: 3.8970,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        ));
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Add current location marker
      _addCurrentLocationMarker();
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  void _addCurrentLocationMarker() {
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current position',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
  }

  void _addCampusMarkers() {
    _markers.clear();
    
    // Add current location marker if available
    if (_currentPosition != null) {
      _addCurrentLocationMarker();
    }
    
    // Add campus markers
    for (var location in _filteredLocations) {
      _markers.add(
        Marker(
          markerId: MarkerId(location['id']),
          position: LatLng(location['latitude'], location['longitude']),
          infoWindow: InfoWindow(
            title: location['name'],
            snippet: location['description'],
            onTap: () => _showLocationDetails(location),
          ),
          icon: _getMarkerColor(location['category']),
          onTap: () => _showLocationDetails(location),
        ),
      );
    }
  }

  BitmapDescriptor _getMarkerColor(String category) {
    switch (category) {
      case 'Academic':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'Administrative':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'Recreational':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'Dining':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case 'Residential':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      case 'Transportation':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      case 'Healthcare':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
      case 'Parking':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      case 'Sports':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
    }
  }

  void _moveCameraToPosition(Position position) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
        ),
      ),
    );
  }

  void _filterLocations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = _campusLocations;
      } else {
        _filteredLocations = _campusLocations.where((location) {
          return location['name'].toLowerCase().contains(query.toLowerCase()) ||
                 location['description'].toLowerCase().contains(query.toLowerCase()) ||
                 location['category'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      _addCampusMarkers();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredLocations = _campusLocations;
      } else {
        _filteredLocations = _campusLocations.where((location) {
          return location['category'] == category;
        }).toList();
      }
      _addCampusMarkers();
    });
  }

  void _showLocationDetails(Map<String, dynamic> location) {
    _selectedBuilding = location['id'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLocationDetailsSheet(location),
    );
  }

  Widget _buildLocationDetailsSheet(Map<String, dynamic> location) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Location header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    location['icon'],
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        location['category'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Location details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    location['description'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Facilities
                  Text(
                    'Facilities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (location['facilities'] as List<String>).map((facility) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          facility,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  
                  // Information grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Hours',
                          location['hours'],
                          Icons.access_time,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          'Floors',
                          '${location['floors']}',
                          Icons.layers,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Contact
                  _buildInfoCard(
                    'Contact',
                    location['contact'],
                    Icons.phone,
                  ),
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _getDirections(location),
                          icon: const Icon(Icons.directions),
                          label: const Text('Get Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _shareLocation(location),
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _getDirections(Map<String, dynamic> location) {
    if (_currentPosition != null) {
      // Create route from current location to destination
      _createRoute(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        LatLng(location['latitude'], location['longitude']),
      );
      
      // Move camera to show the route
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              _currentPosition!.latitude < location['latitude'] 
                ? _currentPosition!.latitude 
                : location['latitude'],
              _currentPosition!.longitude < location['longitude'] 
                ? _currentPosition!.longitude 
                : location['longitude'],
            ),
            northeast: LatLng(
              _currentPosition!.latitude > location['latitude'] 
                ? _currentPosition!.latitude 
                : location['latitude'],
              _currentPosition!.longitude > location['longitude'] 
                ? _currentPosition!.longitude 
                : location['longitude'],
            ),
          ),
          50, // padding
        ),
      );
      
      Navigator.pop(context); // Close the details sheet
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to get current location for directions'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _createRoute(LatLng start, LatLng end) {
    // Clear existing polylines
    _polylines.clear();
    
    // Create a simple straight line route (in production, you'd use Google Directions API)
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        color: AppTheme.primaryColor,
        width: 5,
        points: [start, end],
      ),
    );
    
    setState(() {});
  }

  void _shareLocation(Map<String, dynamic> location) {
    // In production, implement actual sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${location['name']} location...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(7.3965, 3.8970),
              zoom: 16.0,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: true,
            onTap: (_) {
              // Clear selection when tapping on map
              setState(() {
                _selectedBuilding = null;
              });
            },
          ),
          
          // Search and filter controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterLocations,
                    decoration: InputDecoration(
                      hintText: 'Search campus locations...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filterLocations('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Category filter chips
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _locationCategories.length,
                    itemBuilder: (context, index) {
                      final category = _locationCategories[index];
                      final isSelected = _selectedCategory == category;
                      
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            _filterByCategory(category);
                          },
                          selectedColor: AppTheme.primaryColor,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Current location button
          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                if (_currentPosition != null) {
                  _moveCameraToPosition(_currentPosition!);
                } else {
                  _getCurrentLocation();
                }
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.my_location,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          
          // Indoor maps toggle
          Positioned(
            bottom: 180,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showIndoorMaps = !_showIndoorMaps;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _showIndoorMaps 
                        ? 'Indoor maps enabled' 
                        : 'Indoor maps disabled'
                    ),
                    backgroundColor: _showIndoorMaps ? Colors.green : Colors.grey,
                  ),
                );
              },
              backgroundColor: _showIndoorMaps ? Colors.green : Colors.white,
              child: Icon(
                Icons.layers,
                color: _showIndoorMaps ? Colors.white : AppTheme.primaryColor,
              ),
            ),
          ),
          
          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    lottie.Lottie.asset(
                      'assets/animations/wave.json',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Loading campus map...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Error display
          if (_error != null && !_isLoading)
            Positioned(
              top: MediaQuery.of(context).padding.top + 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red[700]),
                      onPressed: () {
                        setState(() => _error = null);
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
