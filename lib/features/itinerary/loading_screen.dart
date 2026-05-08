import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/itinerary_provider.dart';
import 'itinerary_screen.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  late Timer _timer;
  int _messageIndex = 0;

  final List<String> _loadingMessages = [
    'Analyzing travel preferences...',
    'Optimizing itinerary...',
    'Finding suitable experiences...',
    'Planning your trip intelligently...',
    'Calibrating local adventure feeds...',
    'Synthesizing absolute dream map...',
  ];

  @override
  void initState() {
    super.initState();
    _startMessageRotation();
  }

  void _startMessageRotation() {
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _loadingMessages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _retry() {
    final prefs = ref.read(preferencesProvider);
    ref.read(itineraryProvider.notifier).generate(prefs);
  }

  @override
  Widget build(BuildContext context) {
    final itineraryState = ref.watch(itineraryProvider);

    // Reactively listen to generation state and navigate on Success
    ref.listen(itineraryProvider, (previous, next) {
      next.whenOrNull(
        data: (tripPlan) {
          if (tripPlan != null && mounted) {
            // Push replacement so they don't back-navigate to the loader
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ItineraryTimelineScreen(tripPlan: tripPlan),
              ),
            );
          }
        },
      );
    });

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
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: itineraryState.when(
              loading: () => _buildLoadingState(),
              error: (err, st) => _buildErrorState(err.toString()),
              data: (plan) {
                // If it's already generated but hasn't fully transited yet
                if (plan != null) {
                  return _buildTransitioningState();
                }
                return _buildLoadingState();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Premium Space Engine Core Spinner Animation
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.deepPurpleAccent, Colors.pinkAccent],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurpleAccent.withOpacity(0.5),
                  blurRadius: 45,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: const Center(
              child: SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 1.5.seconds)
              .rotate(duration: 5.seconds),
          const SizedBox(height: 48),
          
          Text(
            'EXPERIENCE ENGINE WORKING',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.pinkAccent,
              letterSpacing: 2.2,
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 16),
          
          SizedBox(
            height: 50,
            child: Text(
              _loadingMessages[_messageIndex],
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ).animate(key: ValueKey(_messageIndex)).fadeIn().slideY(begin: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildTransitioningState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.greenAccent,
            size: 80,
          ).animate().scale(duration: 400.ms),
          const SizedBox(height: 24),
          Text(
            'Trip Synthesized Perfectly!',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Opening your curated timeline...',
            style: GoogleFonts.inter(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMsg) {
    // Simplify error message for readability
    final displayError = errorMsg.replaceAll('Exception: ', '');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.pinkAccent,
              size: 60,
            ),
          ).animate().shake(duration: 500.ms),
          const SizedBox(height: 24),
          Text(
            'Synthesizer Encountered a Snag',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            displayError,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white60,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          
          // Retry button
          GestureDetector(
            onTap: _retry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.pinkAccent],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Retry Generation',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          TextButton(
            onPressed: () {
              ref.read(itineraryProvider.notifier).clear();
              Navigator.pop(context);
            },
            child: Text(
              'Back to Preferences',
              style: GoogleFonts.outfit(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
