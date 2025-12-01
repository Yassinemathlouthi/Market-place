import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import '../models/service_item.dart';
import 'data_service.dart';

class AppwriteService implements DataService {
  final Client client = Client();
  late final Databases databases;

  // User provided IDs
  final String projectId = '692e06ce00199fb41678';
  final String databaseId = '692e06f30032cdc6d967';

  // You need to create a collection in your database and put its ID here
  // For now, I'll use a placeholder. REPLACE THIS after creating the collection.
  final String collectionId = 'services';

  AppwriteService() {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(projectId)
        .setSelfSigned(status: true); // For development only

    databases = Databases(client);
  }

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
}
