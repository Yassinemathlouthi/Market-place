import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import '../models/service_item.dart';
import '../models/review.dart';
import '../models/chat_message.dart';
import '../models/booking.dart';
import 'data_service.dart';

class AppwriteService implements DataService {
  final Client client = Client();
  late final Databases databases;
  late final Account account;
  late final Realtime realtime;

  // User provided IDs
  final String projectId = '692e06ce00199fb41678';
  final String databaseId = '692e06f30032cdc6d967';

  // You need to create a collection in your database and put its ID here
  // For now, I'll use a placeholder. REPLACE THIS after creating the collection.
  final String collectionId = 'services';
  final String reviewsCollectionId = 'reviews';
  final String messagesCollectionId = 'messages';
  final String bookingsCollectionId = 'bookings';

  AppwriteService() {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(projectId)
        .setSelfSigned(status: true); // For development only

    databases = Databases(client);
    account = Account(client);
    realtime = Realtime(client);
  }

  // --- AUTHENTICATION METHODS ---

  Future<User?> getCurrentUser() async {
    try {
      return await account.get();
    } catch (e) {
      return null;
    }
  }

  Future<User> register(String email, String password, String name) async {
    try {
      return await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<Session> login(String email, String password) async {
    try {
      return await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  // --- DATABASE METHODS ---

  @override
  Future<List<ServiceItem>> getServices() async {
    try {
      final documentList = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      return documentList.documents
          .map((doc) => ServiceItem.fromMap(doc.data, id: doc.$id))
          .toList();
    } catch (e) {
      debugPrint('Appwrite Error: $e');
      // Fallback to empty list or handle error
      return [];
    }
  }

  @override
  Future<List<ServiceItem>> searchServices(String query) async {
    try {
      final documentList = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.search('title', query), // Requires a FullText index on 'title'
        ],
      );
      return documentList.documents
          .map((doc) => ServiceItem.fromMap(doc.data, id: doc.$id))
          .toList();
    } catch (e) {
      debugPrint('Appwrite Search Error: $e');
      return [];
    }
  }

  @override
  Future<List<ServiceItem>> getServicesByCategory(String category) async {
    if (category == 'All') return getServices();

    try {
      final documentList = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [Query.equal('category', category)],
      );
      return documentList.documents
          .map((doc) => ServiceItem.fromMap(doc.data, id: doc.$id))
          .toList();
    } catch (e) {
      debugPrint('Appwrite Filter Error: $e');
      return [];
    }
  }

  @override
  Future<void> createService(ServiceItem item) async {
    try {
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: item.toMap(),
      );
    } catch (e) {
      debugPrint('Appwrite Create Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Review>> getReviews(String serviceId) async {
    try {
      final documentList = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: reviewsCollectionId,
        queries: [
          Query.equal('serviceId', serviceId),
          Query.orderDesc('\$createdAt'),
        ],
      );

      return documentList.documents
          .map((doc) => Review.fromMap(doc.data, id: doc.$id))
          .toList();
    } catch (e) {
      debugPrint('Appwrite Get Reviews Error: $e');
      return [];
    }
  }

  @override
  Future<void> createReview(Review review) async {
    try {
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: reviewsCollectionId,
        documentId: ID.unique(),
        data: review.toMap(),
      );
    } catch (e) {
      debugPrint('Appwrite Create Review Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<ChatMessage>> getMessages(String chatId) async {
    try {
      final documentList = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: messagesCollectionId,
        queries: [Query.equal('chatId', chatId), Query.orderAsc('\$createdAt')],
      );

      return documentList.documents
          .map((doc) => ChatMessage.fromMap(doc.data, id: doc.$id))
          .toList();
    } catch (e) {
      debugPrint('Appwrite Get Messages Error: $e');
      return [];
    }
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    try {
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: messagesCollectionId,
        documentId: ID.unique(),
        data: message.toMap(),
      );
    } catch (e) {
      debugPrint('Appwrite Send Message Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final documentList = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: bookingsCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.orderDesc('bookingDate'),
        ],
      );

      return documentList.documents
          .map((doc) => Booking.fromMap(doc.data, id: doc.$id))
          .toList();
    } catch (e) {
      debugPrint('Appwrite Get Bookings Error: $e');
      return [];
    }
  }

  @override
  Future<void> createBooking(Booking booking) async {
    try {
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: bookingsCollectionId,
        documentId: ID.unique(),
        data: booking.toMap(),
      );
    } catch (e) {
      debugPrint('Appwrite Create Booking Error: $e');
      rethrow;
    }
  }
}
