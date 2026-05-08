import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/trip_plan.dart';
import '../../providers/itinerary_provider.dart';
import '../../widgets/glass_container.dart';

class ItineraryTimelineScreen extends ConsumerStatefulWidget {
  final TripPlan tripPlan;

  const ItineraryTimelineScreen({super.key, required this.tripPlan});

  @override
  ConsumerState<ItineraryTimelineScreen> createState() => _ItineraryTimelineScreenState();
}

class _ItineraryTimelineScreenState extends ConsumerState<ItineraryTimelineScreen> {
  int _selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    final plan = widget.tripPlan;
    
    // Safety check in case the response doesn't contain any days
    final List<TripDay> days = plan.days;
    final TripDay? currentDay = days.isNotEmpty && _selectedDayIndex < days.length
        ? days[_selectedDayIndex]
        : null;

    final activities = currentDay?.activities ?? [];

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
              // Top Action bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Clear provider state and pop back
                        ref.read(itineraryProvider.notifier).clear();
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                    Text(
                      'AI Engineered Itinerary',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 44), // Alignment balance
                  ],
                ),
              ),

              // Summary Banner
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
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'CURATED TRIP',
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
                              const Icon(Icons.calendar_today, color: Colors.deepPurpleAccent, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                '${days.length} ${days.length == 1 ? "Day" : "Days"}',
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
                        plan.tripSummary.isNotEmpty 
                            ? plan.tripSummary 
                            : 'Your custom-designed day-by-day travel plan is ready.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.4,
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
                                style: GoogleFonts.inter(fontSize: 10, color: Colors.white38, letterSpacing: 1.1),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                plan.totalEstimatedBudget.isNotEmpty ? plan.totalEstimatedBudget : 'N/A',
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
                                'PREFERENCES',
                                style: GoogleFonts.inter(fontSize: 10, color: Colors.white38, letterSpacing: 1.1),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ref.read(preferencesProvider).pace,
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

              // Day Tabs Selector
              if (days.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SizedBox(
                    height: 48,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedDayIndex == index;
                        final dayNum = days[index].day;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDayIndex = index;
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

              // Activities Timeline
              Expanded(
                child: activities.isEmpty
                    ? Center(
                        child: Text(
                          'No activities returned for this day.',
                          style: GoogleFonts.inter(color: Colors.white38),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0, bottom: 100.0),
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final act = activities[index];
                          final isFirst = index == 0;
                          final isLast = index == activities.length - 1;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Timeline Line & Bullet
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
                                      height: 200, // Fixed timeline height to prevent squishing
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.access_time, color: Colors.pinkAccent, size: 14),
                                                const SizedBox(width: 6),
                                                Text(
                                                  act.time,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.pinkAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.greenAccent.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                act.estimatedCost,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.greenAccent,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          act.title,
                                          style: GoogleFonts.outfit(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          act.description,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Colors.white60,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        
                                        // AI Reasoning field - explicitly designed to highlight recommendation rationale
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.deepPurpleAccent.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.15)),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.auto_awesome,
                                                color: Colors.pinkAccent,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'WHY Gemini SELECED THIS',
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.pinkAccent,
                                                        letterSpacing: 1.1,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      act.reasoning,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 11,
                                                        color: Colors.white70,
                                                        fontStyle: FontStyle.italic,
                                                        height: 1.3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ).animate(key: ValueKey('${_selectedDayIndex}_$index')).fadeIn(duration: 400.ms).slideY(begin: 0.05),
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
      // Bottom CTA
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: GestureDetector(
          onTap: () {
            ref.read(itineraryProvider.notifier).clear();
            Navigator.pop(context);
          },
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
                const Icon(Icons.arrow_back, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Plan Another Adventure',
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
      ).animate().slideY(begin: 0.5, delay: 500.ms, duration: 500.ms),
    );
  }
}
