import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';

class CommentRepository {
  final _comments = FirebaseFirestore.instance.collection('comments');

  Stream<List<CommentModel>> getCommentsForPost(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      print("Fetched comments: ${snapshot.docs.length}");  // Debugging line
      return snapshot.docs
          .map((doc) => CommentModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addComment({
    required String postId,
    required String userId,
    required String userName,
    required String comment,
  }) async {
    await _comments.add({
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print("✅ Comment added to Firestore: $comment"); // <-- Add this line
  }



}
