import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  /* Create 作成 */
  Future<void> addTaskToCurrentUser(String taskName) async {
    // 現在のユーザーを取得
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid; // 現在のユーザーのIDを取得

      // ユーザーのタスクコレクションにタスクを追加
      await db.collection('users').doc(userId).collection('tasks').add(
        {
          "task_name": taskName,
          "created_at": FieldValue.serverTimestamp(), // タスク作成時刻を追加
        },
      );
    } else {
      // ユーザーがサインインしていない場合のエラーハンドリング
      throw Exception('User is not signed in.');
    }
  }
}
