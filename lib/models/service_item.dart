class ServiceItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String providerName;
  final String contactInfo;
  final String category;
  final String? imageUrl;

  ServiceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.providerName,
    required this.contactInfo,
    required this.category,
    this.imageUrl,
  });

  factory ServiceItem.fromMap(Map<String, dynamic> map, {String? id}) {
    return ServiceItem(
      id: id ?? map['\$id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : (map['price'] ?? 0.0).toDouble(),
      providerName: map['provider'] ?? '',
      contactInfo: map['contact'] ?? '',
      category: map['category'] ?? 'General',
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'provider': providerName,
      'contact': contactInfo,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}
