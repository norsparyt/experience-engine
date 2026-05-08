import '../models/destination.dart';
import '../models/experience.dart';
import '../models/trip.dart';

class ExperienceEngineService {
  // --- STATIC MOCK DATA ---
  static const List<Experience> _kyotoExperiences = [
    Experience(
      id: 'e1_kyoto',
      title: 'Fushimi Inari Shrine Early Hike',
      description: 'Hike through thousands of iconic red torii gates before the crowds arrive. Discover hidden shrines and panoramic city views.',
      imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=600&auto=format&fit=crop',
      category: 'Culture & Nature',
      price: 25.0,
      rating: 4.9,
      duration: '3 hours',
      location: 'Kyoto, Japan',
      tags: ['hiking', 'shrine', 'scenic', 'early-morning'],
    ),
    Experience(
      id: 'e2_kyoto',
      title: 'Zen Tea Ceremony & Meditation',
      description: 'Experience an authentic, private matcha tea ceremony led by a licensed master in a historic 400-year-old wooden townhouse.',
      imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=600&auto=format&fit=crop',
      category: 'Wellness & Culture',
      price: 65.0,
      rating: 4.8,
      duration: '2 hours',
      location: 'Kyoto, Japan',
      tags: ['meditation', 'tea', 'traditional', 'relaxing'],
    ),
    Experience(
      id: 'e3_kyoto',
      title: 'Bamboo Forest & Monkey Park Tour',
      description: 'Walk through Arashiyama’s towering green stalks and climb up to Iwatayama Monkey Park to feed wild Japanese macaques.',
      imageUrl: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?q=80&w=600&auto=format&fit=crop',
      category: 'Adventure & Nature',
      price: 40.0,
      rating: 4.7,
      duration: '4 hours',
      location: 'Kyoto, Japan',
      tags: ['bamboo', 'monkeys', 'nature', 'active'],
    ),
    Experience(
      id: 'e4_kyoto',
      title: 'Gion Evening Kaiseki Dining',
      description: 'Stroll through the Gion geisha district followed by an exquisite multi-course seasonal Kaiseki feast in a traditional tatami room.',
      imageUrl: 'https://images.unsplash.com/photo-1542013936693-8848e5740a15?q=80&w=600&auto=format&fit=crop',
      category: 'Food',
      price: 120.0,
      rating: 4.95,
      duration: '3 hours',
      location: 'Kyoto, Japan',
      tags: ['food', 'luxury', 'traditional', 'dinner'],
    ),
    Experience(
      id: 'e5_kyoto',
      title: 'Kinkaku-ji (Golden Pavilion) & Rock Garden',
      description: 'Marvel at the spectacular gold-leaf Zen temple reflecting on Mirror Pond and decipher the rock alignment at Ryoan-ji temple.',
      imageUrl: 'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?q=80&w=600&auto=format&fit=crop',
      category: 'Culture',
      price: 15.0,
      rating: 4.6,
      duration: '2.5 hours',
      location: 'Kyoto, Japan',
      tags: ['temple', 'gardens', 'zen', 'photography'],
    ),
  ];

  static const List<Experience> _reykjavikExperiences = [
    Experience(
      id: 'e1_reyk',
      title: 'Northern Lights Midnight Hunt',
      description: 'Venture out of the city lights into the dark Icelandic wilderness to witness the dancing aurora borealis with a local expert guide.',
      imageUrl: 'https://images.unsplash.com/photo-1529963183134-61a90db47eaf?q=80&w=600&auto=format&fit=crop',
      category: 'Nature & Adventure',
      price: 85.0,
      rating: 4.8,
      duration: '4 hours',
      location: 'Reykjavik, Iceland',
      tags: ['aurora', 'night', 'scenic', 'cold-weather'],
    ),
    Experience(
      id: 'e2_reyk',
      title: 'Blue Lagoon Geothermal Spa Ritual',
      description: 'Soak in silica-rich milky blue waters, enjoy a silica mud mask, and indulge in a swim-up bar massage at the world-famous geothermal spa.',
      imageUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=600&auto=format&fit=crop',
      category: 'Wellness',
      price: 110.0,
      rating: 4.7,
      duration: 'Full day',
      location: 'Reykjavik, Iceland',
      tags: ['spa', 'thermal', 'relaxing', 'luxury'],
    ),
    Experience(
      id: 'e3_reyk',
      title: 'Golden Circle Glacier Superjeep Expedition',
      description: 'Hop onto an 8x8 monster truck to traverse massive glaciers and see Gullfoss waterfall and Strokkur geyser blow hot steam into the air.',
      imageUrl: 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&w=600&auto=format&fit=crop',
      category: 'Adventure',
      price: 195.0,
      rating: 4.9,
      duration: '8 hours',
      location: 'Reykjavik, Iceland',
      tags: ['glacier', 'jeep', 'waterfalls', 'adrenaline'],
    ),
    Experience(
      id: 'e4_reyk',
      title: 'Volcanic Cave Exploration',
      description: 'Descend into a thousands-of-years-old lava tube Leidarendi. Witness beautiful ice sculptures and rock formations in the earth.',
      imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=600&auto=format&fit=crop',
      category: 'Adventure',
      price: 70.0,
      rating: 4.6,
      duration: '3 hours',
      location: 'Reykjavik, Iceland',
      tags: ['cave', 'volcano', 'geology', 'active'],
    ),
  ];

  static const List<Experience> _santoriniExperiences = [
    Experience(
      id: 'e1_santo',
      title: 'Sunset Catamaran Luxury Cruise',
      description: 'Sail the caldera basin, stop for swimming at Red Beach and hot springs, and watch the breathtaking Oia sunset from the catamaran deck.',
      imageUrl: 'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?q=80&w=600&auto=format&fit=crop',
      category: 'Relaxation',
      price: 150.0,
      rating: 4.95,
      duration: '5 hours',
      location: 'Santorini, Greece',
      tags: ['sailing', 'sunset', 'romantic', 'swimming'],
    ),
    Experience(
      id: 'e2_santo',
      title: 'Cliffside Wine Tasting & Pairing',
      description: 'Sip unique volcanic wines like Assyrtiko at a dramatic cliffside estate overlooking the Aegean Sea during golden hour.',
      imageUrl: 'https://images.unsplash.com/photo-1506377247377-2a5b3b417ebb?q=80&w=600&auto=format&fit=crop',
      category: 'Food & Culture',
      price: 80.0,
      rating: 4.8,
      duration: '3 hours',
      location: 'Santorini, Greece',
      tags: ['wine', 'scenic', 'romantic', 'food'],
    ),
    Experience(
      id: 'e3_santo',
      title: 'Fira to Oia Ridge Hike',
      description: 'Embark on a famous 10km scenic trail winding along the caldera edge through white-washed villages and iconic blue-domed churches.',
      imageUrl: 'https://images.unsplash.com/photo-1533105079780-92b9be482077?q=80&w=600&auto=format&fit=crop',
      category: 'Nature & Adventure',
      price: 0.0,
      rating: 4.9,
      duration: '4 hours',
      location: 'Santorini, Greece',
      tags: ['hiking', 'scenic', 'free', 'photography'],
    ),
  ];

  static const List<Experience> _queenstownExperiences = [
    Experience(
      id: 'e1_queens',
      title: 'Nevis Bungy Jump (134m)',
      description: 'Take the ultimate leap of faith from a highwire cabin suspended 134 meters above the roaring Nevis River canyon.',
      imageUrl: 'https://images.unsplash.com/photo-1530789253388-582c481c54b0?q=80&w=600&auto=format&fit=crop',
      category: 'Adventure',
      price: 180.0,
      rating: 4.9,
      duration: '4 hours',
      location: 'Queenstown, New Zealand',
      tags: ['bungy', 'adrenaline', 'heights', 'active'],
    ),
    Experience(
      id: 'e2_queens',
      title: 'Milford Sound Wilderness Cruise & Fly',
      description: 'Fly over Southern Alps glaciers and board a boutique cruise vessel to witness towering waterfalls, seals, and penguins.',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=600&auto=format&fit=crop',
      category: 'Nature',
      price: 350.0,
      rating: 4.98,
      duration: 'Full day',
      location: 'Queenstown, New Zealand',
      tags: ['helicopter', 'cruise', 'nature', 'luxury'],
    ),
    Experience(
      id: 'e3_queens',
      title: 'Shotover Jet Boat Thrill Ride',
      description: 'Speed through narrow, rocky canyons at 85km/h with mind-boggling 360-degree spins on the Shotover River.',
      imageUrl: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?q=80&w=600&auto=format&fit=crop',
      category: 'Adventure',
      price: 90.0,
      rating: 4.7,
      duration: '1.5 hours',
      location: 'Queenstown, New Zealand',
      tags: ['jetboat', 'adrenaline', 'river', 'fast'],
    ),
  ];

  static final List<Destination> destinations = [
    const Destination(
      id: 'd1_kyoto',
      name: 'Kyoto',
      description: 'The ancient capital of Japan, famous for its thousands of classical Buddhist temples, gardens, imperial palaces, Shinto shrines, and traditional wooden houses.',
      imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=1000&auto=format&fit=crop',
      country: 'Japan',
      rating: 4.85,
      category: 'Cultural',
      experiences: _kyotoExperiences,
    ),
    const Destination(
      id: 'd2_reykjavik',
      name: 'Reykjavik',
      description: 'Capital city of Iceland, serving as a gateway to spectacular natural wonders—from active volcanoes and glaciers to geothermal spas and the magical northern lights.',
      imageUrl: 'https://images.unsplash.com/photo-1504829857797-ddff28127792?q=80&w=1000&auto=format&fit=crop',
      country: 'Iceland',
      rating: 4.75,
      category: 'Adventure & Nature',
      experiences: _reykjavikExperiences,
    ),
    const Destination(
      id: 'd3_santorini',
      name: 'Santorini',
      description: 'One of the Cyclades islands in the Aegean Sea. Ruined by a volcanic eruption in the 16th century BC, it features spectacular clifftop towns with white-washed buildings and blue domes.',
      imageUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=1000&auto=format&fit=crop',
      country: 'Greece',
      rating: 4.9,
      category: 'Relaxation & Coastal',
      experiences: _santoriniExperiences,
    ),
    const Destination(
      id: 'd4_queenstown',
      name: 'Queenstown',
      description: 'Nestled on the shores of Lake Wakatipu beneath the Dramatic Remarkables mountain range, Queenstown is renowned as the Adventure Capital of the World.',
      imageUrl: 'https://images.unsplash.com/photo-1589871189143-a1410c611ff2?q=80&w=1000&auto=format&fit=crop',
      country: 'New Zealand',
      rating: 4.8,
      category: 'Alpine & Adventure',
      experiences: _queenstownExperiences,
    ),
  ];

  // --- RECONSTRUCTION ENGINE ALGORITHM ---
  Trip generateRecommendedTrip({
    required Destination destination,
    required DateTime startDate,
    required DateTime endDate,
    required double maxBudget,
    required String travelStyle, // "Adventure", "Relaxation", "Wellness", "Cultural", "Culinary"
  }) {
    final int daysCount = endDate.difference(startDate).inDays + 1;
    final Map<int, List<Experience>> itinerary = {};

    // Filter destination experiences based on style and budget
    List<Experience> availableExperiences = List.from(destination.experiences);

    // Filter experiences by style
    List<Experience> primaryExperiences = availableExperiences.where((exp) {
      final tagsAndCat = [...exp.tags, exp.category.toLowerCase()];
      if (travelStyle.toLowerCase() == 'adventure') {
        return tagsAndCat.contains('active') || tagsAndCat.contains('adrenaline') || tagsAndCat.contains('hiking') || exp.category.toLowerCase().contains('adventure');
      } else if (travelStyle.toLowerCase() == 'relaxation') {
        return tagsAndCat.contains('relaxing') || tagsAndCat.contains('spa') || tagsAndCat.contains('scenic') || tagsAndCat.contains('romantic') || exp.category.toLowerCase().contains('relaxation');
      } else if (travelStyle.toLowerCase() == 'cultural') {
        return tagsAndCat.contains('traditional') || tagsAndCat.contains('shrine') || tagsAndCat.contains('temple') || exp.category.toLowerCase().contains('culture');
      }
      return true; // Match all for fallback
    }).toList();

    // If no specific match, use all experiences
    if (primaryExperiences.isEmpty) {
      primaryExperiences = availableExperiences;
    }

    // Sort by rating
    primaryExperiences.sort((a, b) => b.rating.compareTo(a.rating));

    // Distribute experiences to days (max 2 experiences per day: Morning/Afternoon and Evening)
    int expIndex = 0;
    double currentSpent = 0.0;

    for (int day = 1; day <= daysCount; day++) {
      itinerary[day] = [];

      // Add a daytime experience
      if (primaryExperiences.isNotEmpty) {
        final exp = primaryExperiences[expIndex % primaryExperiences.length];
        if (currentSpent + exp.price <= maxBudget) {
          itinerary[day]!.add(exp);
          currentSpent += exp.price;
          expIndex++;
        }
      }

      // Add an evening/secondary experience if budget permits
      if (primaryExperiences.isNotEmpty) {
        final secondaryExp = primaryExperiences[(expIndex + 1) % primaryExperiences.length];
        // Ensure it's not the same as daytime exp if possible
        if (secondaryExp.id != itinerary[day]!.firstOrNull?.id) {
          if (currentSpent + secondaryExp.price <= maxBudget) {
            itinerary[day]!.add(secondaryExp);
            currentSpent += secondaryExp.price;
            expIndex += 2;
          }
        }
      }

      // Fallback: If day itinerary is empty, add any free or cheap activity
      if (itinerary[day]!.isEmpty && destination.experiences.isNotEmpty) {
        final cheapest = destination.experiences.reduce((a, b) => a.price < b.price ? a : b);
        if (currentSpent + cheapest.price <= maxBudget) {
          itinerary[day]!.add(cheapest);
          currentSpent += cheapest.price;
        }
      }
    }

    return Trip(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Dream $travelStyle Getaway in ${destination.name}',
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      itinerary: itinerary,
      totalBudget: currentSpent,
      travelStyle: travelStyle,
    );
  }
}
