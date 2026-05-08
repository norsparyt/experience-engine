import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/trip.dart';
import '../widgets/glass_container.dart';

class ItineraryScreen extends StatefulWidget {
  final Trip trip;

  const ItineraryScreen({super.key, required this.trip});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  int _selectedDay = 1;

  void _showBookingConfirmation() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Booking Confirmation',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curve,
          child: AlertDialog(
            backgroundColor: const Color(0xFF1E1035),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: Colors.deepPurpleAccent.withOpacity(0.3)),
            ),
            title: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.greenAccent,
                  size: 50,
                ).animate().scale(duration: 500.ms),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Trip Booked!',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your personalized ${widget.trip.travelStyle} escape to ${widget.trip.destination.name} has been successfully saved to your profile and experiences synchronized.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Pop back to Engine Screen
                  Navigator.pop(context); // Pop back to Home Screen
                },
                child: Text(
                  'Awesome, Return Home',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final dayExperiences = trip.itinerary[_selectedDay] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1035),
              Color(0xFF0F0C20),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      ),
                    ),
                    Text(
                      'Your Custom Plan',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 44), // To balance out back button
                  ],
                ),
              ),

              // Summary Header Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: GlassContainer(
                  blur: 20,
                  opacity: 0.12,
                  borderColor: Colors.deepPurpleAccent.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              trip.travelStyle.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.pinkAccent, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                '${trip.durationInDays} Days',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        trip.title,
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white12, height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL ESTIMATED PRICE',
                                style: GoogleFonts.inter(fontSize: 10, color: Colors.white38),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${trip.totalBudget.toInt()}',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'DESTINATION',
                                style: GoogleFonts.inter(fontSize: 10, color: Colors.white38),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${trip.destination.name}, ${trip.destination.country}',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05),

              // Day Tab Selector
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: trip.durationInDays,
                    itemBuilder: (context, index) {
                      final dayNum = index + 1;
                      final isSelected = _selectedDay == dayNum;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDay = dayNum;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(colors: [Colors.deepPurpleAccent, Colors.pinkAccent])
                                : null,
                            color: isSelected ? null : Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Day $dayNum',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.white : Colors.white60,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Daily Itinerary Activities Timeline
              Expanded(
                child: dayExperiences.isEmpty
                    ? Center(
                        child: Text(
                          'No activities planned for this day.',
                          style: GoogleFonts.inter(color: Colors.white38),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0, bottom: 100.0),
                        itemCount: dayExperiences.length,
                        itemBuilder: (context, index) {
                          final exp = dayExperiences[index];
                          final isFirst = index == 0;
                          final isLast = index == dayExperiences.length - 1;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sleek Left Timeline Line & Bullet
                              Column(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: isFirst ? Colors.pinkAccent : Colors.deepPurpleAccent,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isFirst ? Colors.pinkAccent : Colors.deepPurpleAccent).withOpacity(0.5),
                                          blurRadius: 6,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isLast)
                                    Container(
                                      width: 2,
                                      height: 150,
                                      color: Colors.deepPurpleAccent.withOpacity(0.3),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              // Activity Details Card
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 24),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.04),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        child: SizedBox(
                                          height: 110,
                                          width: double.infinity,
                                          child: Image.network(
                                            exp.imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  isFirst ? 'MORNING / AFTERNOON' : 'EVENING / DINNER',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w800,
                                                    color: isFirst ? Colors.pinkAccent : Colors.deepPurpleAccent,
                                                    letterSpacing: 1.1,
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
                                            const SizedBox(height: 8),
                                            Text(
                                              exp.title,
                                              style: GoogleFonts.outfit(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              exp.description,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: Colors.white60,
                                                height: 1.4,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.access_time, color: Colors.white38, size: 14),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      exp.duration,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        color: Colors.white60,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  exp.price == 0 ? 'Free' : '\$${exp.price.toInt()}',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.pinkAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate(key: ValueKey('${_selectedDay}_$index')).fadeIn(duration: 400.ms).slideY(begin: 0.05),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Bar Floating CTA to Save Trip
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: GestureDetector(
          onTap: _showBookingConfirmation,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Colors.pinkAccent, Colors.deepPurpleAccent],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bookmark_added, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Book & Save Experience',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().slideY(begin: 0.5, delay: 600.ms, duration: 500.ms),
    );
  }
}
