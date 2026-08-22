class RecyclingCentre {
  final String id;
  final String name;
  final String address;
  final String city;
  final double distanceKm;
  final String contactNumber;
  final String email;
  final String operatingHours;
  final bool isOpen;
  final List<String> acceptedMaterials;
  final List<String> unsupportedMaterials;
  final String notes;

  const RecyclingCentre({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.distanceKm,
    required this.contactNumber,
    required this.email,
    required this.operatingHours,
    required this.isOpen,
    required this.acceptedMaterials,
    required this.unsupportedMaterials,
    required this.notes,
  });
}

