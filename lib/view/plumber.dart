class PlumberDetails {
  final String userId;
  final String name;
  final String location;
  final int rating;
  final int contact;
  final double latitude;
  final double longitude;
  final double distance; 
  final int experience;
  final String profession;
  final bool available; 

  PlumberDetails({
    required this.userId,
    required this.name,
    required this.location,
    required this.rating,
    required this.contact,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.experience,
    required this.profession,
    required this.available,
  });

  factory PlumberDetails.fromMap(Map<String, dynamic> map) {
  try {
    return PlumberDetails(
      userId: map['userId'] ?? '', // Provide a default value if null
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      rating: (map['rating']) ?? 5,
      contact: map['contact'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      distance: (map['distance'] as num?)?.toDouble() ?? 0.0,
      experience: (map['experience']) ?? 0,
      profession: (map['profession']) ?? '',
      available: (map['available']) ?? false,
    );
  } catch (e) {
    print('Error creating PlumberDetails: $e');
    throw e;
  }
}}