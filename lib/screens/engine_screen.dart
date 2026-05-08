import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/destination.dart';
import '../services/experience_engine.dart';
import '../widgets/glass_container.dart';
import 'itinerary_screen.dart';

class ExperienceEngineScreen extends StatefulWidget {
  const ExperienceEngineScreen({super.key});

  @override
  State<ExperienceEngineScreen> createState() => _ExperienceEngineScreenState();
}

class _ExperienceEngineScreenState extends State<ExperienceEngineScreen> {
  final _engineService = ExperienceEngineService();
  
  // Selected configuration
  Destination _selectedDestination = ExperienceEngineService.destinations.first;
  String _selectedStyle = 'Adventure';
  double _budgetLimit = 400.0;
  int _tripDays = 3;

  bool _isGenerating = false;
  String _generatingText = 'Analyzing preferences...';

  final List<String> _styles = ['Adventure', 'Relaxation', 'Cultural'];

  void _triggerGeneration() async {
    setState(() {
      _isGenerating = true;
      _generatingText = 'Calibrating Experience Engine™...';
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {
      _generatingText = 'Selecting curated local guides...';
    });

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _generatingText = 'Generating custom-tailored day-by-day itinerary...';
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    final today = DateTime.now();
    final endDate = today.add(Duration(days: _tripDays - 1));

    final trip = _engineService.generateRecommendedTrip(
      destination: _selectedDestination,
      startDate: today,
      endDate: endDate,
      maxBudget: _budgetLimit,
      travelStyle: _selectedStyle,
    );

    setState(() {
      _isGenerating = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItineraryScreen(trip: trip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Experience Engine™',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
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
        child: Stack(
          children: [
            // Config Wizard
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Customizer',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Let our engine design your ideal, tailored vacation.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // STEP 1: Select Destination
                    Text(
                      'Step 1: Pick Destination',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: ExperienceEngineService.destinations.length,
                        itemBuilder: (context, index) {
                          final dest = ExperienceEngineService.destinations[index];
                          final isSelected = _selectedDestination.id == dest.id;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDestination = dest;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 140,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? Colors.deepPurpleAccent : Colors.white10,
                                  width: isSelected ? 2 : 1,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(dest.imageUrl),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(isSelected ? 0.3 : 0.6),
                                    BlendMode.darken,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  dest.name,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),

                    // STEP 2: Select Travel Style
                    Text(
                      'Step 2: Define Travel Vibe',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: _styles.map((style) {
                        final isSelected = _selectedStyle == style;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedStyle = style;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: isSelected
                                    ? Colors.deepPurpleAccent.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.04),
                                border: Border.all(
                                  color: isSelected ? Colors.deepPurpleAccent : Colors.white10,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    style == 'Adventure'
                                        ? Icons.hiking
                                        : style == 'Relaxation'
                                            ? Icons.spa
                                            : Icons.museum,
                                    color: isSelected ? Colors.deepPurpleAccent : Colors.white54,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    style,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? Colors.white : Colors.white60,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),

                    // STEP 3: Duration Slider
                    Text(
                      'Step 3: Duration (Days)',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GlassContainer(
                      blur: 15,
                      opacity: 0.05,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'How long is your escape?',
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.white54),
                              ),
                              Text(
                                '$_tripDays Days',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pinkAccent,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _tripDays.toDouble(),
                            min: 1,
                            max: 7,
                            divisions: 6,
                            activeColor: Colors.deepPurpleAccent,
                            inactiveColor: Colors.white12,
                            onChanged: (val) {
                              setState(() {
                                _tripDays = val.toInt();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // STEP 4: Budget Slider
                    Text(
                      'Step 4: Max Experience Budget',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GlassContainer(
                      blur: 15,
                      opacity: 0.05,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Maximum activity limit',
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.white54),
                              ),
                              Text(
                                '\$${_budgetLimit.toInt()}',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pinkAccent,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _budgetLimit,
                            min: 50,
                            max: 1000,
                            divisions: 19,
                            activeColor: Colors.deepPurpleAccent,
                            inactiveColor: Colors.white12,
                            onChanged: (val) {
                              setState(() {
                                _budgetLimit = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Generate Button
                    GestureDetector(
                      onTap: _triggerGeneration,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Colors.deepPurpleAccent, Colors.pinkAccent],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurpleAccent.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.auto_awesome, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Generate Experience Itinerary',
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
                    ).animate().scale(delay: 400.ms),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Loading overlay
            if (_isGenerating)
              Container(
                color: Colors.black.withOpacity(0.85),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Space Engine Core Animation
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.deepPurpleAccent, Colors.pinkAccent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurpleAccent.withOpacity(0.5),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                strokeWidth: 5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        ).animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 1.5.seconds)
                            .rotate(duration: 4.seconds),
                        const SizedBox(height: 40),
                        Text(
                          'ENGINE PROCESSING',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.pinkAccent,
                            letterSpacing: 2,
                          ),
                        ).animate().fadeIn(),
                        const SizedBox(height: 12),
                        Text(
                          _generatingText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate(key: ValueKey(_generatingText)).fadeIn().slideY(begin: 0.1),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
