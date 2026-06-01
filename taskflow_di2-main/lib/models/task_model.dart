class Task {
  final String id;
  final String title;
  final bool done;
  final String userId;
  final DateTime? createdAt;

  Task(
      {required this.id,
      required this.done,
      this.createdAt,
      required this.title,
      required this.userId});

      // Firestore -> Task

      factory Task.fromFirestore( String id, Map<String , dynamic> data){
        return Task(
          id:id,
          title: data['title'] ?? '',
          done: data['done'] ?? false,
          userId: data['userId'] ?? '',
          createdAt: data['createdAt']?.toDate(),
        );
      }
      // Task to Firestore 
      Map<String, dynamic> toMap(){
        return {
          'title': title,
          'done': done,
          'userId': userId
        };
      }
}
