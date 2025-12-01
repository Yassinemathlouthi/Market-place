class Booking {
  final String id;
  final String serviceId;
  final String serviceTitle;
  final String userId;
  final String providerName;
  final DateTime bookingDate;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.serviceId,
    required this.serviceTitle,
    required this.userId,
    required this.providerName,
    required this.bookingDate,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromMap(Map<String, dynamic> map, {String? id}) {
    return Booking(
      id: id ?? map['\$id'] ?? '',
      serviceId: map['serviceId'] ?? '',
      serviceTitle: map['serviceTitle'] ?? '',
      userId: map['userId'] ?? '',
      providerName: map['providerName'] ?? '',
      bookingDate: map['bookingDate'] != null
          ? DateTime.parse(map['bookingDate'])
          : DateTime.now(),
      status: map['status'] ?? 'pending',
      createdAt: map['\$createdAt'] != null
          ? DateTime.parse(map['\$createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'serviceTitle': serviceTitle,
      'userId': userId,
      'providerName': providerName,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
    };
  }
}
