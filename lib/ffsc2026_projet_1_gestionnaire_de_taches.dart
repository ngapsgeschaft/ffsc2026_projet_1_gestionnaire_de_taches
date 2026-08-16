import 'dart:convert';
import 'dart:core';
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
  String toString() {
    return 'Task(id: $id, titre: $title, priority: ${priority.designation}, due date: ${dueDate ?? ''}, isCompleted: ${isCompleted ? 'oui' : 'non'} )';
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'priority': priority.name,
    'dueDate': dueDate?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == json['priority'] as String,
        orElse: () => TaskPriority.low,
      ),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

enum TaskPriority {
  low('Low'),
  medium('Medium'),
  high('High');

  const TaskPriority(this.designation);
  final String designation;

  @override
  String toString() {
    return designation;
  }
}

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
        createTask(taskRepository);
        break;
      case UserChoice.deleteTask:
        deleteTask(taskRepository);
        break;
      case UserChoice.listTasks:
        listTasks(taskRepository);
        break;
      case UserChoice.markTaskCompleted:
        markAsComplete(taskRepository);
        break;
      default:
    }
    return false;
  }
}

void markAsComplete(TaskRepository taskRepository) {
  print('Veuillez entrer l\'id de la tâche:');
  String? id = stdin.readLineSync();
  try {
    Task task = taskRepository.getById(id ?? '').copyWith(isCompleted: true);
    taskRepository.update(task);
    print('Tâche accomplie avec succès!');
  } on TaskNotFoundException {
    print('Tâche avec l\'id \'$id\' introuvée.');
  }
}

void listTasks(TaskRepository taskRepository) {
  List<Task> tasks = taskRepository.getAll();
  if (tasks.isEmpty) {
    print('\t>>>>> Liste de tâches vide <<<<<');
  } else {
    for (var task in tasks) {
      print(task);
    }
  }
}

void deleteTask(TaskRepository taskRepository) {
  print('Veuillez entrer l\'id de la tâche à supprimer');
  String? id = stdin.readLineSync();
  taskRepository.delete(id ?? '');
  print('Tâche supprimée avec succès!');
}

void createTask(TaskRepository taskRepository) {
  print('Entrez les détails de la tâche.');
  print('Id:');
  String? id = stdin.readLineSync();
  print('Title:');
  String? title = stdin.readLineSync();
  print('Priority ([low]/medium/high):');
  String? priority = stdin.readLineSync();
  print('Due date (YYYY-MM-DD):');
  String? dueDate = stdin.readLineSync();
  print('Tâche complète (oui/[non]):');
  String? isComplete = stdin.readLineSync();
  Task task = Task(
    id: id ?? 'X',
    title: title ?? 'Titre X',
    priority: parseTaskPriority(priority) ?? TaskPriority.low,
    dueDate: DateTime.tryParse(dueDate ?? ''),
    isCompleted: bool.tryParse(isComplete ?? '') ?? false,
  );
  taskRepository.add(task);
  print('Tâche ajoutée avec succès!');
  print(task);
}

TaskPriority? parseTaskPriority(String? priority) {
  for (var p in TaskPriority.values) {
    if (p.designation == priority) {
      return p;
    }
  }
  return null;
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
