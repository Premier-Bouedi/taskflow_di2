import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskflow_di2/models/task_model.dart';
import 'package:taskflow_di2/services/auth/auth_service.dart';
import 'package:taskflow_di2/services/auth/tasks/task_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = TextEditingController();
  final _taskService = TaskService();
  final _authService = AuthService();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _addTask(String userId) async {
    final title = _taskController.text.trim();
    if (title.isEmpty) return;
    await _taskService.addTask(userId, title);
    _taskController.clear();
  }

  Widget _buildTaskTile(Task task) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Checkbox(
        value: task.done,
        onChanged: (value) {
          if (value == null) return;
          _taskService.updateTask(task.id, value);
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.done ? TextDecoration.lineThrough : TextDecoration.none,
          color: task.done ? Colors.grey : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        onPressed: () => _taskService.deleteTask(task.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    const indigo = Color(0xFF4F46E5);
    const indigoLight = Color(0xFFEEF2FF);
    const textPrimary = Color(0xFF111827);
    const textSecondary = Color(0xFF6B7280);
    const borderColor = Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Taskflow',
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () async => await _authService.logout(),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: indigoLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout, size: 16, color: textSecondary),
                  SizedBox(width: 6),
                  Text(
                    'Deconnexion',
                    style: TextStyle(color: textSecondary, fontSize: 13),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour, ${user?.displayName ?? 'utilisateur'}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: indigoLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      controller: _taskController,
                      decoration: const InputDecoration(
                        hintText: 'Nouvelle tâche',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onSubmitted: (_) {
                        if (user != null) {
                          _addTask(user.uid);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: user == null ? null : () => _addTask(user.uid),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: indigo,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Ajouter'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (user == null)
              const Expanded(child: Center(child: Text('Aucun utilisateur connecté.')))
            else
              Expanded(
                child: StreamBuilder<List<Task>>(
                  stream: _taskService.getTasksStream(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Erreur lors du chargement des tâches'));
                    }

                    final tasks = snapshot.data ?? [];
                    final completedTasks = tasks.where((task) => task.done).toList();
                    final pendingTasks = tasks.where((task) => !task.done).toList();

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tâches à faire',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          if (pendingTasks.isEmpty)
                            const Text('Aucune tâche à faire pour le moment.')
                          else
                            ...pendingTasks.map(_buildTaskTile),
                          const SizedBox(height: 24),
                          const Text(
                            'Tâches terminées',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          if (completedTasks.isEmpty)
                            const Text('Aucune tâche terminée pour le moment.')
                          else
                            ...completedTasks.map(_buildTaskTile),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
