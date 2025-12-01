import '../models/service_item.dart';
import '../models/review.dart';
import '../models/chat_message.dart';
import '../models/booking.dart';

abstract class DataService {
  Future<List<ServiceItem>> getServices();
  Future<List<ServiceItem>> searchServices(String query);
  Future<List<ServiceItem>> getServicesByCategory(String category);
  Future<void> createService(ServiceItem item);

  // Reviews
  Future<List<Review>> getReviews(String serviceId);
  Future<void> createReview(Review review);

  // Chat
  Future<List<ChatMessage>> getMessages(String chatId);
  Future<void> sendMessage(ChatMessage message);

  // Bookings
  Future<List<Booking>> getUserBookings(String userId);
  Future<void> createBooking(Booking booking);
}

class MockDataService implements DataService {
  final List<ServiceItem> _items = [
    ServiceItem(
      id: '1',
      title: 'Logo Design',
      description:
          'Professional logo design for your brand. Includes 3 revisions and source files.',
      price: 50.0,
      providerName: 'Alice Creative',
      contactInfo: 'alice@example.com',
      category: 'Design',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1661963874418-df1110ee39c1?w=500&auto=format&fit=crop&q=60',
    ),
    ServiceItem(
      id: '2',
      title: 'House Cleaning',
      description:
          'Full house cleaning service. 3 hours max. Eco-friendly products used.',
      price: 80.0,
      providerName: 'CleanFast Services',
      contactInfo: '+1234567890',
      category: 'Home',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1661662946877-269fae63f416?w=500&auto=format&fit=crop&q=60',
    ),
    ServiceItem(
      id: '3',
      title: 'Flutter Development',
      description: 'Fix bugs or build small features for your Flutter app.',
      price: 40.0,
      providerName: 'DevExpert',
      contactInfo: 'dev@code.com',
      category: 'Tech',
      imageUrl:
          'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=500&auto=format&fit=crop&q=60',
    ),
    ServiceItem(
      id: '4',
      title: 'Piano Lessons',
      description: '1 hour piano lesson for beginners. Online or in-person.',
      price: 30.0,
      providerName: 'MusicMaster',
      contactInfo: 'music@piano.com',
      category: 'Education',
      imageUrl:
          'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=500&auto=format&fit=crop&q=60',
    ),
    ServiceItem(
      id: '5',
      title: 'Plumbing Repair',
      description: 'Emergency plumbing repair. Available 24/7.',
      price: 100.0,
      providerName: 'Joe Plumber',
      contactInfo: 'joe@plumber.com',
      category: 'Home',
      imageUrl:
          'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?w=500&auto=format&fit=crop&q=60',
    ),
  ];

  final List<Review> _reviews = [];

  @override
  Future<List<ServiceItem>> getServices() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _items;
  }

  @override
  Future<List<ServiceItem>> searchServices(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _items
        .where(
          (item) =>
              item.title.toLowerCase().contains(query.toLowerCase()) ||
              item.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<List<ServiceItem>> getServicesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (category == 'All') return _items;
    return _items.where((item) => item.category == category).toList();
  }

  @override
  Future<void> createService(ServiceItem item) async {
    _items.add(item);
  }

  @override
  Future<List<Review>> getReviews(String serviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _reviews.where((r) => r.serviceId == serviceId).toList();
  }

  @override
  Future<void> createReview(Review review) async {
    _reviews.add(review);
  }

  final List<ChatMessage> _messages = [];

  @override
  Future<List<ChatMessage>> getMessages(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _messages.where((m) => m.chatId == chatId).toList();
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    _messages.add(message);
  }

  final List<Booking> _bookings = [];

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _bookings.where((b) => b.userId == userId).toList();
  }

  @override
  Future<void> createBooking(Booking booking) async {
    _bookings.add(booking);
  }
}
