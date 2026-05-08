import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/trip_plan.dart';
import '../../providers/itinerary_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  final List<Activity> activities;
  final int dayIndex;

  const MapScreen({
    super.key,
    required this.activities,
    required this.dayIndex,
  });

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  int _activeCardIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  // Breathtaking, customized deep space/royal purple dark map styling JSON
  static const String _darkMapStyle = '''
  [
    { "elementType": "geometry", "stylers": [{ "color": "#150C26" }] },
    { "elementType": "labels.text.fill", "stylers": [{ "color": "#8F82AC" }] },
    { "elementType": "labels.text.stroke", "stylers": [{ "color": "#150C26" }] },
    { "featureType": "administrative", "elementType": "geometry.stroke", "stylers": [{ "color": "#3E2B5C" }] },
    { "featureType": "landscape", "elementType": "geometry", "stylers": [{ "color": "#150C26" }] },
    { "featureType": "poi", "elementType": "geometry", "stylers": [{ "color": "#1E1235" }] },
    { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [{ "color": "#A092BF" }] },
    { "featureType": "road", "elementType": "geometry", "stylers": [{ "color": "#281943" }] },
    { "featureType": "road", "elementType": "geometry.stroke", "stylers": [{ "color": "#1E1235" }] },
    { "featureType": "road", "elementType": "labels.text.fill", "stylers": [{ "color": "#8F82AC" }] },
    { "featureType": "transit", "elementType": "geometry", "stylers": [{ "color": "#1E1235" }] },
    { "featureType": "water", "elementType": "geometry", "stylers": [{ "color": "#0B0418" }] }
  ]
  ''';

  @override
  void dispose() {
    _mapController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController?.setMapStyle(_darkMapStyle);
    _fitMapToMarkers();
  }

  void _fitMapToMarkers() {
    if (widget.activities.isEmpty || _mapController == null) return;

    double minLat = 90.0, maxLat = -90.0, minLng = 180.0, maxLng = -180.0;
    bool hasCoords = false;

    for (final act in widget.activities) {
      if (act.latitude != null && act.longitude != null) {
        hasCoords = true;
        if (act.latitude! < minLat) minLat = act.latitude!;
        if (act.latitude! > maxLat) maxLat = act.latitude!;
        if (act.longitude! < minLng) minLng = act.longitude!;
        if (act.longitude! > maxLng) maxLng = act.longitude!;
      }
    }

    if (!hasCoords) return;

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - 0.01, minLng - 0.01),
          northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
        ),
        60.0, // padding
      ),
    );
  }

  void _onCardChanged(int index) {
    setState(() {
      _activeCardIndex = index;
    });

    final act = widget.activities[index];
    if (act.latitude != null && act.longitude != null && _mapController != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(act.latitude!, act.longitude!),
          15.0,
        ),
      );
    }
  }

  void _openDetailsBottomSheet(Activity act) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF160E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pull Bar indicator
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Beautiful Place Photo Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      act.imageUrl ?? 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 90,
                        height: 90,
                        color: Colors.white10,
                        child: const Icon(Icons.image_not_supported, color: Colors.white24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Primary Metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          act.title,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              act.rating?.toStringAsFixed(1) ?? '4.5',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.pinkAccent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                act.openingHours ?? 'Open Now',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          act.address ?? '128 Curated St, Experience City',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Text(
                'VISITING INSIGHTS',
                style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1.1),
              ),
              const SizedBox(height: 6),
              Text(
                act.description,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 24),
              
              // Bottom Action Button row
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Colors.deepPurpleAccent, Colors.pinkAccent],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Add stop to My Trip',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Center(
                        child: Icon(Icons.navigation, color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Fetch decoded route coordinates from state provider per active day
    final Map<int, List<LatLng>> routePoints = ref.watch(routePointsProvider);
    final List<LatLng> activePoints = routePoints[widget.dayIndex] ?? [];

    // 2. Map activities list to Marker sets dynamically
    final Set<Marker> markers = widget.activities
        .where((act) => act.latitude != null && act.longitude != null)
        .map((act) {
          final isSelected = widget.activities.indexOf(act) == _activeCardIndex;
          return Marker(
            markerId: MarkerId(act.title),
            position: LatLng(act.latitude!, act.longitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              isSelected ? BitmapDescriptor.hueRose : BitmapDescriptor.hueViolet,
            ),
            onTap: () {
              final idx = widget.activities.indexOf(act);
              _pageController.animateToPage(
                idx,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              _openDetailsBottomSheet(act);
            },
          );
        })
        .toSet();

    // 3. Connect markers with high premium pink/purple gradient polylines
    final Set<Polyline> polylines = {
      if (activePoints.isNotEmpty)
        Polyline(
          polylineId: PolylineId('route_day_${widget.dayIndex}'),
          points: activePoints,
          color: Colors.pinkAccent,
          width: 5,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
    };

    final CameraPosition initialCamera = widget.activities.isNotEmpty &&
            widget.activities[0].latitude != null &&
            widget.activities[0].longitude != null
        ? CameraPosition(
            target: LatLng(widget.activities[0].latitude!, widget.activities[0].longitude!),
            zoom: 13.0,
          )
        : const CameraPosition(
            target: LatLng(26.9124, 75.7873),
            zoom: 13.0,
          );

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20),
      body: Stack(
        children: [
          // Full Screen Google Map Core View
          GoogleMap(
            initialCameraPosition: initialCamera,
            onMapCreated: _onMapCreated,
            markers: markers,
            polylines: polylines,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
          ),

          // Custom Dark Glass Overlay Headers
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xCC0F0C20), Color(0x000F0C20)],
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF160E2E).withOpacity(0.85),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day ${widget.dayIndex + 1} Path Visualization',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.activities.length} Stops • Route Connected Perfectly',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Horizontal Floating Activities Details Cards at the bottom of the map
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: SizedBox(
              height: 120,
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: _onCardChanged,
                itemCount: widget.activities.length,
                itemBuilder: (context, index) {
                  final act = widget.activities[index];
                  final isCurrent = index == _activeCardIndex;

                  return GestureDetector(
                    onTap: () => _openDetailsBottomSheet(act),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCurrent ? const Color(0xFF1E1035).withOpacity(0.95) : const Color(0xFF0F0C20).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isCurrent ? Colors.pinkAccent.withOpacity(0.6) : Colors.white10,
                          width: isCurrent ? 2 : 1,
                        ),
                        boxShadow: [
                          if (isCurrent)
                            BoxShadow(
                              color: Colors.pinkAccent.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isCurrent ? Colors.pinkAccent : Colors.white.withOpacity(0.04),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent ? Colors.white : Colors.white38,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  act.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, color: Colors.pinkAccent, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      act.time,
                                      style: GoogleFonts.inter(fontSize: 11, color: Colors.white60),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 14),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
