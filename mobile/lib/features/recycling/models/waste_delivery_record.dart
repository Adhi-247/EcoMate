class WasteDeliveryRecord {
  final String id;
  final String? recyclingCentreId;
  final String? recyclingCentreName;
  final String materialType;
  final double weightKg;
  final String deliveredBy;
  final String contactNumber;
  final DateTime dateTime;
  final String notes;

  const WasteDeliveryRecord({
    required this.id,
    this.recyclingCentreId,
    this.recyclingCentreName,
    required this.materialType,
    required this.weightKg,
    required this.deliveredBy,
    required this.contactNumber,
    required this.dateTime,
    required this.notes,
  });

  factory WasteDeliveryRecord.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = json['dateTime'] != null
          ? DateTime.parse(json['dateTime'].toString())
          : DateTime.now();
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return WasteDeliveryRecord(
      id: json['id'] != null ? 'DEL-${json['id']}' : 'DEL-0',
      recyclingCentreId: json['recyclingCentreId']?.toString(),
      recyclingCentreName: json['recyclingCentreName']?.toString(),
      materialType: json['materialType']?.toString() ?? '',
      weightKg: (json['weightKg'] is num) ? (json['weightKg'] as num).toDouble() : 0.0,
      deliveredBy: json['deliveredBy']?.toString() ?? '',
      contactNumber: json['contactNumber']?.toString() ?? '',
      dateTime: parsedDate,
      notes: json['notes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recyclingCentreId': recyclingCentreId != null ? int.tryParse(recyclingCentreId!) : null,
      'materialType': materialType,
      'weightKg': weightKg,
      'deliveredBy': deliveredBy,
      'contactNumber': contactNumber,
      'notes': notes,
    };
  }
}
