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

  Future<void> deleteTaskFromCurrentUser(String taskId) async {
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;

      await db
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(taskId)
          .delete();
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

  Future<List<Map<String, String>>> getTasksByUsername(String username) async {
    try {
      final userId = await getUserIdFromUsername(username);

      if (userId != null) {
        final querySnapshot = await db
            .collection('users')
            .doc(userId)
            .collection('tasks')
            .orderBy('created_at', descending: true)
            .get();

        // タスク名とドキュメントIDをリストとして返す
        return querySnapshot.docs.map((doc) {
          return {
            "id": doc.id,
            "task_name": doc.data()['task_name'] as String,
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('エラーが発生しました: $e');
    }
  }

  /* 現在ログインしているユーザーの友達リストを取得 */
  Future<List<Map<String, String>>> getFriendsList() async {
    try {
      // 現在ログインしているユーザーのUIDを取得
      User? currentUser = auth.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;

        // 現在ログインしているユーザーの「friends」サブコレクションを取得
        final querySnapshot = await db
            .collection('users')
            .doc(userId)
            .collection('friends')
            .get();

        // 友達リストのデータをリストとして返す
        return querySnapshot.docs.map((doc) {
          return {
            "id": doc.id,
            "username": doc.data()['username'] as String,
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('エラーが発生しました: $e');
    }
  }

  /* フレンドリストに友達を追加し、相手のフレンドリストにも自分を追加 */
  Future<void> addFriend(String friendUsername) async {
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;

      try {
        // Get the friend user's ID from their username
        final friendUserId = await getUserIdFromUsername(friendUsername);

        if (friendUserId != null) {
          // Add friend to current user's friend list
          await db
              .collection('users')
              .doc(userId)
              .collection('friends')
              .doc(friendUserId)
              .set({
            'username': friendUsername,
            'added_at': FieldValue.serverTimestamp(),
          });

          // Add current user to friend's friend list
          final currentUserName = await getUsernameFromUserId(userId);
          if (currentUserName != null) {
            await db
                .collection('users')
                .doc(friendUserId)
                .collection('friends')
                .doc(userId)
                .set({
              'username': currentUserName,
              'added_at': FieldValue.serverTimestamp(),
            });
          }
        } else {
          throw Exception('Friend user not found.');
        }
      } catch (e) {
        throw Exception('Error adding friend: $e');
      }
    } else {
      throw Exception('User is not signed in.');
    }
  }
}
