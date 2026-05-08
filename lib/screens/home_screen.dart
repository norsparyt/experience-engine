import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/destination.dart';
import '../services/experience_engine.dart';
import '../widgets/glass_container.dart';
import 'destination_detail_screen.dart';
import 'engine_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = ['All', 'Cultural', 'Adventure & Nature', 'Relaxation & Coastal', 'Alpine & Adventure'];

  List<Destination> get _filteredDestinations {
    return ExperienceEngineService.destinations.where((dest) {
      final matchesCategory = _selectedCategory == 'All' || dest.category == _selectedCategory;
      final matchesSearch = dest.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dest.country.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20), // Rich dark blue-space background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1035), // Dark purple/violet glow at the top
              Color(0xFF0F0C20), // Pure rich space black/dark blue
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Area with User Profile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore the World',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white60,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Hey Adventurer 👋',
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop'),
                        ),
                      ).animate().scale(delay: 100.ms, duration: 500.ms),
                    ],
                  ),
                ),

                // AI Engine Promo Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ExperienceEngineScreen()),
                      );
                    },
                    child: GlassContainer(
                      blur: 20,
                      opacity: 0.12,
                      borderColor: Colors.deepPurpleAccent.withOpacity(0.4),
                      gradientColors: [
                        Colors.deepPurpleAccent.withOpacity(0.25),
                        Colors.pinkAccent.withOpacity(0.1),
                      ],
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'AI ENGINE ACTIVE',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Experience Engine™',
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Generate custom itineraries powered by your mood, preferences, and budget.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Colors.deepPurpleAccent, Colors.pinkAccent],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurpleAccent.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 30,
                            ),
                          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                              .shimmer(duration: 2.seconds, color: Colors.white54)
                              .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1.2.seconds),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.1),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search, color: Colors.white54),
                        hintText: 'Search destinations, activities...',
                        hintStyle: GoogleFonts.inter(color: Colors.white38),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),

                // Categories Row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(colors: [Colors.deepPurpleAccent, Color(0xFF8E2DE2)])
                                  : null,
                              color: isSelected ? null : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : Colors.white.withOpacity(0.1),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.deepPurpleAccent.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Text(
                              category,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.white60,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Featured Destinations Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Destinations',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'See All',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Destinations Cards Carousel
                SizedBox(
                  height: 330,
                  child: _filteredDestinations.isEmpty
                      ? Center(
                          child: Text(
                            'No destinations match your search.',
                            style: GoogleFonts.inter(color: Colors.white38),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(left: 24.0, right: 12.0),
                          itemCount: _filteredDestinations.length,
                          itemBuilder: (context, index) {
                            final dest = _filteredDestinations[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DestinationDetailScreen(destination: dest),
                                  ),
                                );
                              },
                              child: Container(
                                width: 220,
                                margin: const EdgeInsets.only(right: 16, bottom: 12, top: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // Image
                                      Hero(
                                        tag: 'dest_img_${dest.id}',
                                        child: Image.network(
                                          dest.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // Dark Gradient Overlay
                                      Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black54,
                                              Colors.black87,
                                            ],
                                            stops: [0.3, 0.7, 1.0],
                                          ),
                                        ),
                                      ),
                                      // Content
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on, color: Colors.pinkAccent, size: 14),
                                                const SizedBox(width: 4),
                                                Text(
                                                  dest.country,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              dest.name,
                                              style: GoogleFonts.outfit(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.15),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.star, color: Colors.amber, size: 12),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '${dest.rating}',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  '${dest.experiences.length} Experiences',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11,
                                                    color: Colors.white60,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).animate(delay: (index * 100).ms).fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
                            );
                          },
                        ),
                ),

                // Trending Activities Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Text(
                    'Trending Activities',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Trending Activities List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    // Combine all experiences for trending
                    final allExps = ExperienceEngineService.destinations.expand((d) => d.experiences).toList();
                    if (index >= allExps.length) return const SizedBox.shrink();
                    final exp = allExps[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                exp.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurpleAccent.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          exp.category,
                                          style: GoogleFonts.inter(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.amber, size: 12),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${exp.rating}',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    exp.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    exp.location,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: Colors.white38,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        exp.duration,
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: Colors.white60,
                                        ),
                                      ),
                                      Text(
                                        exp.price == 0 ? 'Free' : '\$${exp.price.toInt()}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pinkAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: (400 + index * 100).ms).fadeIn(duration: 500.ms).slideY(begin: 0.1);
                  },
                ),
                const SizedBox(height: 80), // Extra space for scrolling content past FAB/bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
