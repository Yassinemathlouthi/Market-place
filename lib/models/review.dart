class Review {
  final String id;
  final String serviceId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map, {String? id}) {
    return Review(
      id: id ?? map['\$id'] ?? '',
      serviceId: map['serviceId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      rating: (map['rating'] is int)
          ? (map['rating'] as int).toDouble()
          : (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
      createdAt: map['\$createdAt'] != null
          ? DateTime.parse(map['\$createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
    };
  }
}
