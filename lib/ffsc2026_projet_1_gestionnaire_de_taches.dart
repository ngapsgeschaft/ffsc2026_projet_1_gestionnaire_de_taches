import 'dart:io';

void run() {
  introduce();
  bool terminate = false;
  TaskRepository taskRepository = TaskRepository();
  while (!terminate) {
    printMenu();
    print('Veuillez entrer votre choix :');
    String? input = stdin.readLineSync();
    try {
      UserChoice choice = getUserChoice(input);
      print('\nVous avez choisi ${choice.value}: ${choice.description}.');
      terminate = executeAndTerminate(choice, taskRepository);
    } on ChoiceException {
      print('\nChoix "$input" invalide. Veuillez réessayer.');
    }
  }
}

class TaskRepository implements Repository<Task> {
  final List<Task> _tasks = [];

  @override
  void add(Task task) {
    _tasks.add(task);
  }

  @override
  void delete(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  @override
  List<Task> getAll() {
    return List.unmodifiable(_tasks);
  }

  @override
  Task getById(String id) {
    return _tasks.firstWhere(
      (task) => task.id == id,
      orElse: () =>
          throw TaskNotFoundException('Task with id \'$id\' not found.'),
    );
  }

  @override
  void update(Task aTask) {
    for (var i = 0; i < _tasks.length; i++) {
      if (_tasks[i].id == aTask.id) {
        _tasks[i] = aTask.copyWith();
      }
    }
  }
}

class TaskNotFoundException implements Exception {
  final String message;
  TaskNotFoundException(this.message);

  @override
  String toString() => 'TaskNotFoundException: $message';
}

class Task {
  final String id;
  final String title;
  final TaskPriority priority;
  final DateTime? dueDate;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    required this.isCompleted,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => Object.hash(id, title, priority, dueDate, isCompleted);

  Task copyWith({
    String? id,
    String? title,
    TaskPriority? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    priority: priority ?? this.priority,
    dueDate: dueDate ?? this.dueDate,
    isCompleted: isCompleted ?? this.isCompleted,
  );
}

enum TaskPriority { low, medium, high }

abstract class Repository<T> {
  List<T> getAll();
  T getById(String id);
  void add(T item);
  void update(T item);
  void delete(String id);
}

bool executeAndTerminate(UserChoice choice, TaskRepository taskRepository) {
  if (choice == UserChoice.quit) {
    return true;
  } else {
    switch (choice) {
      case UserChoice.createTask:
        createTask();
        break;
      case UserChoice.deleteTask:
        deleteTask();
        break;
      case UserChoice.listTasks:
        listTasks();
        break;
      case UserChoice.markTaskCompleted:
        markAsComplete();
        break;
      default:
    }
    return false;
  }
}

void markAsComplete() {
  print('Mark a task as completed.');
}

void listTasks() {
  print('List all tasks.');
}

void deleteTask() {
  print('Delete a task.');
}

void createTask() {
  print('Create a task.');
}

void quit() {
  print('Merci d\'avoir utilisé le gestionnaire de tâches. À bientôt !');
}

UserChoice getUserChoice(String? input) {
  for (var choice in UserChoice.values) {
    if (choice.value.toString() == input) {
      return choice;
    }
  }
  throw ChoiceException('Choix "$input" invalide');
}

class ChoiceException implements Exception {
  final String message;
  ChoiceException(this.message);

  @override
  String toString() => 'ChoiceException: $message';
}

void printMenu() {
  print('\n======== Gestionnaire de Tâches ========');
  for (var choice in UserChoice.values) {
    print('${choice.value}. ${choice.description}');
  }
}

enum UserChoice {
  createTask(1, 'Créer une nouvelle tâche'),
  listTasks(2, 'Lister toutes les tâches'),
  markTaskCompleted(3, 'Marquer une tâche comme terminée'),
  deleteTask(4, 'Supprimer une tâche'),
  quit(5, 'Quitter le programme');

  const UserChoice(this.value, this.description);

  final int value;
  final String description;
}

void introduce() {
  print('\nBienvenue dans le gestionnaire de tâches !');
  print('Ce programme vous aidera à gérer vos tâches efficacement.');
}
