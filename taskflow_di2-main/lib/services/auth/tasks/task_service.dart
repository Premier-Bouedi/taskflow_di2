import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskflow_di2/models/task_model.dart';

class TaskService {
  // instancier notre base de donnees
  final _db = FirebaseFirestore.instance;
  final String _collection = 'tasks';
  // Stream en temps reel des taches de l'utilisateur
  Stream<List<Task>> getTasksStream(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  // Ajouter une tache
  Future<void> addTask(String userId, String title) async {
    await _db.collection(_collection).add({
      'title': title,
      'done': false,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Mettre à jour l’état d’une tâche
  Future<void> updateTask(String taskId, bool done) async {
    await _db.collection(_collection).doc(taskId).update({
      'done': done,
    });
  }

  // supprimer une taches
  Future<void> deleteTask(String taskId) async {
    await _db.collection(_collection).doc(taskId).delete();
  }
}
