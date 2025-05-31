import 'package:cloud_firestore/cloud_firestore.dart';

/// Service class for handling Firestore database operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get Firestore instance
  FirebaseFirestore get firestore => _firestore;

  /// Create a document in a collection
  Future<DocumentReference> createDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      throw Exception('Error creating document: $e');
    }
  }

  /// Update a document
  Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).update(data);
    } catch (e) {
      throw Exception('Error updating document: $e');
    }
  }

  /// Delete a document
  Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw Exception('Error deleting document: $e');
    }
  }

  /// Get a document by ID
  Future<DocumentSnapshot> getDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      return await _firestore.collection(collection).doc(documentId).get();
    } catch (e) {
      throw Exception('Error getting document: $e');
    }
  }

  /// Get all documents from a collection
  Future<QuerySnapshot> getCollection({
    required String collection,
    Query Function(CollectionReference)? queryBuilder,
  }) async {
    try {
      CollectionReference collectionRef = _firestore.collection(collection);

      if (queryBuilder != null) {
        return await queryBuilder(collectionRef).get();
      }

      return await collectionRef.get();
    } catch (e) {
      throw Exception('Error getting collection: $e');
    }
  }

  /// Stream documents from a collection
  Stream<QuerySnapshot> streamCollection({
    required String collection,
    Query Function(CollectionReference)? queryBuilder,
  }) {
    try {
      CollectionReference collectionRef = _firestore.collection(collection);

      if (queryBuilder != null) {
        return queryBuilder(collectionRef).snapshots();
      }

      return collectionRef.snapshots();
    } catch (e) {
      throw Exception('Error streaming collection: $e');
    }
  }

  /// Stream a specific document
  Stream<DocumentSnapshot> streamDocument({
    required String collection,
    required String documentId,
  }) {
    try {
      return _firestore.collection(collection).doc(documentId).snapshots();
    } catch (e) {
      throw Exception('Error streaming document: $e');
    }
  }

  /// Batch write operations
  Future<void> batchWrite(List<BatchOperation> operations) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (BatchOperation operation in operations) {
        switch (operation.type) {
          case BatchOperationType.create:
            batch.set(operation.documentRef, operation.data!);
            break;
          case BatchOperationType.update:
            batch.update(operation.documentRef, operation.data!);
            break;
          case BatchOperationType.delete:
            batch.delete(operation.documentRef);
            break;
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Error executing batch operations: $e');
    }
  }
}

/// Enum for batch operation types
enum BatchOperationType { create, update, delete }

/// Class for defining batch operations
class BatchOperation {
  final BatchOperationType type;
  final DocumentReference documentRef;
  final Map<String, dynamic>? data;

  BatchOperation({required this.type, required this.documentRef, this.data});
}
