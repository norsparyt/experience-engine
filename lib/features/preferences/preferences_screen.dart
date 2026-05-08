import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/itinerary_provider.dart';
import '../../widgets/glass_container.dart';
import '../itinerary/loading_screen.dart';

class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _budgetController = TextEditingController(text: '5000');

  final List<String> _interestOptions = [
    'History',
    'Food',
    'Adventure',
    'Nature',
    'Shopping',
    'Nightlife',
    'Culture',
    'Relaxation',
  ];

  final List<String> _paceOptions = ['Relaxed', 'Balanced', 'Fast-paced'];
  
  final List<String> _foodOptions = [
    'Vegetarian',
    'Non-vegetarian',
    'Vegan',
    'No preference',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize text controllers from state if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentPrefs = ref.read(preferencesProvider);
      _destinationController.text = currentPrefs.destination;
      _budgetController.text = currentPrefs.budget.toStringAsFixed(0);
    });
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    // Update state preferences with textual inputs
    final double budgetVal = double.tryParse(_budgetController.text) ?? 5000.0;
    ref.read(preferencesProvider.notifier).updateDestination(_destinationController.text);
    ref.read(preferencesProvider.notifier).updateBudget(budgetVal);

    final prefs = ref.read(preferencesProvider);
    
    if (prefs.interests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.pinkAccent,
          content: Text(
            'Please select at least one interest to customize your trip.',
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
      return;
    }

    // Trigger AI generation
    ref.read(itineraryProvider.notifier).generate(prefs);

    // Navigate to the loading state screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoadingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1035), // Royal purple/violet glow
              Color(0xFF0F0C20), // Deep rich space black/dark blue
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button & header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: Colors.pinkAccent, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              'AI BUILDER ACTIVE',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.pinkAccent,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Dream Vacation Planner',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
                  const SizedBox(height: 6),
                  Text(
                    'Customize your perfect getaway and let the Gemini Engine construct a personalized, logical itinerary.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white60,
                      height: 1.4,
                    ),
                  ).animate().fadeIn(delay: 150.ms, duration: 500.ms),
                  const SizedBox(height: 32),

                  // FIELD 1: Destination
                  Text(
                    'Where do you want to explore?',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _destinationController,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a destination';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.04),
                      hintText: 'e.g. Jaipur, Kyoto, Santorini',
                      hintStyle: GoogleFonts.inter(color: Colors.white30, fontSize: 14),
                      prefixIcon: const Icon(Icons.location_on, color: Colors.pinkAccent, size: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.pinkAccent),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // FIELD 2 & 3: Budget and Duration (Side by side)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Budget Limit (\$)',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _budgetController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter budget';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Invalid number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.04),
                                hintText: 'e.g. 5000',
                                hintStyle: GoogleFonts.inter(color: Colors.white30, fontSize: 14),
                                prefixIcon: const Icon(Icons.attach_money, color: Colors.greenAccent, size: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Colors.pinkAccent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trip Duration',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 54,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.08)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: prefs.days > 1
                                        ? () => ref.read(preferencesProvider.notifier).updateDays(prefs.days - 1)
                                        : null,
                                    icon: const Icon(Icons.remove, color: Colors.white, size: 18),
                                  ),
                                  Text(
                                    '${prefs.days} ${prefs.days == 1 ? "Day" : "Days"}',
                                    style: GoogleFonts.outfit(
                                      color: Colors.pinkAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: prefs.days < 7
                                        ? () => ref.read(preferencesProvider.notifier).updateDays(prefs.days + 1)
                                        : null,
                                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // FIELD 4: Interests Multi-select Chips
                  Text(
                    'Interests & Focus Areas',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _interestOptions.map((interest) {
                      final isSelected = prefs.interests.contains(interest);
                      return GestureDetector(
                        onTap: () => ref.read(preferencesProvider.notifier).toggleInterest(interest),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.deepPurpleAccent.withOpacity(0.2)
                                : Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected ? Colors.deepPurpleAccent : Colors.white.withOpacity(0.08),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected ? Icons.check_circle : Icons.add_circle_outline,
                                color: isSelected ? Colors.deepPurpleAccent : Colors.white30,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                interest,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.white : Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // FIELD 5: Travel Pace
                  Text(
                    'Ideal Travel Pace',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: _paceOptions.map((pace) {
                      final isSelected = prefs.pace == pace;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => ref.read(preferencesProvider.notifier).updatePace(pace),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: isSelected
                                  ? Colors.deepPurpleAccent.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.04),
                              border: Border.all(
                                color: isSelected ? Colors.deepPurpleAccent : Colors.white.withOpacity(0.08),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                pace,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.white : Colors.white60,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // FIELD 6: Food Preference
                  Text(
                    'Food Preferences',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: prefs.foodPreference,
                        dropdownColor: const Color(0xFF1E1035),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60),
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                        isExpanded: true,
                        items: _foodOptions.map((food) {
                          return DropdownMenuItem<String>(
                            value: food,
                            child: Text(food),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(preferencesProvider.notifier).updateFoodPreference(val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Submit Button
                  GestureDetector(
                    onTap: _submitForm,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Generate Smart Trip',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().scale(delay: 300.ms),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
