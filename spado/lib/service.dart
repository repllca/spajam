import 'package:cloud_firestore/cloud_firestore.dart';

class Firestoreservice {
  final db = FirebaseFirestore.instance;

  /* Create 作成 */
  Future<void> addTaskToUser(String userId, String taskName) async {
    // ユーザーのタスクコレクションにタスクを追加
    await db.collection('users').doc(userId).collection('tasks').add(
      {
        "task_name": taskName,
        "created_at": FieldValue.serverTimestamp(), // タスク作成時刻を追加
      },
    );
  }
}
