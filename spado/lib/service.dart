import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  /* Create 作成 */
  Future<void> addTaskToCurrentUser(String taskName) async {
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;

      await db.collection('users').doc(userId).collection('tasks').add(
        {
          "task_name": taskName,
          "created_at": FieldValue.serverTimestamp(),
        },
      );
    } else {
      throw Exception('User is not signed in.');
    }
  }

  /* ユーザーネームからUIDを取得 */
  Future<String?> getUserIdFromUsername(String username) async {
    try {
      final querySnapshot = await db
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id; // ドキュメントIDがUID
      } else {
        return null; // ユーザーネームが見つからない場合
      }
    } catch (e) {
      throw Exception('エラーが発生しました: $e');
    }
  }

  /* UIDからユーザーネームを取得 */
  Future<String?> getUsernameFromUserId(String userId) async {
    try {
      final docSnapshot = await db.collection('users').doc(userId).get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?['username'];
      } else {
        return null; // ユーザーが見つからない場合
      }
    } catch (e) {
      throw Exception('エラーが発生しました: $e');
    }
  }

  /* ユーザーネームからそのユーザーが持っているタスクを取得 */
  Future<List<String>> getTasksByUsername(String username) async {
    try {
      final userId = await getUserIdFromUsername(username);

      if (userId != null) {
        final querySnapshot = await db
            .collection('users')
            .doc(userId)
            .collection('tasks')
            .orderBy('created_at', descending: true)
            .get();

        return querySnapshot.docs
            .map((doc) => doc.data()['task_name'] as String)
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('エラーが発生しました: $e');
    }
  }

  /* Aさんの友達リストにBさんを追加 */
  Future<void> addFriend(String aUsername, String bUsername) async {
    try {
      // AさんとBさんのUIDを取得
      final aUserId = await getUserIdFromUsername(aUsername);
      final bUserId = await getUserIdFromUsername(bUsername);

      if (aUserId != null && bUserId != null) {
        // Aさんの友達リストにBさんのUIDを追加
        await db
            .collection('users')
            .doc(aUserId)
            .collection('friends')
            .doc(bUserId)
            .set({
          'username': bUsername,
          'added_at': FieldValue.serverTimestamp(),
        });

        // Bさんの友達リストにAさんのUIDを追加（双方向の友達リストの場合）
        await db
            .collection('users')
            .doc(bUserId)
            .collection('friends')
            .doc(aUserId)
            .set({
          'username': aUsername,
          'added_at': FieldValue.serverTimestamp(),
        });
      } else {
        throw Exception('AさんまたはBさんが見つかりません。');
      }
    } catch (e) {
      throw Exception('エラーが発生しました: $e');
    }
  }
}
