import 'dart:io';

class TaskManager {
  final List<Task> _tasks = [];

  void addTask(Task aTask) {
    _tasks.add(aTask);
  }

  Task getTaskById(String id) {
    return _tasks.firstWhere((task) => task.id == id);
  }

  void removeTask(Task aTask) {
    _tasks.remove(aTask);
  }

  List<Task> get tasks => List.unmodifiable(_tasks);

  void markTaskCompleted(String aTaskId) {
    final task = getTaskById(aTaskId);
    task.isCompleted = true;
  }
}

class Task {
  final String id;
  String title;
  TaskPriority priority;
  DateTime? dueDate;
  bool isCompleted;

  Task(
    this.id,
    this.title,
    this.priority, {
    this.dueDate,
    this.isCompleted = false,
  });
}

class UrgentTask extends Task {
  UrgentTask(String id, String title, String description, {DateTime? dueDate})
    : super(id, title, TaskPriority.high, dueDate: dueDate);
}

enum TaskPriority { low, medium, high }

void run() {
  introduce();
  while (true) {
    printMenu();
    print('Veuillez entrer votre choix :');
    String? input = stdin.readLineSync();
    try {
      UserChoice choice = getUserChoice(input);
      print('\nVous avez choisi ${choice.value}: ${choice.description}.');
      if (choice == UserChoice.quit) {
        quit();
        return;
      }
    } on ChoiceException {
      print('\nChoix "$input" invalide. Veuillez réessayer.');
    }
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

void printMenu() {
  print('\n======== Gestionnaire de Tâches ========');
  for (var choice in UserChoice.values) {
    print('${choice.value}. ${choice.description}');
  }
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

void quit() {
  print('Merci d\'avoir utilisé le gestionnaire de tâches. À bientôt !');
}

void introduce() {
  print('\nBienvenue dans le gestionnaire de tâches !');
  print('Ce programme vous aidera à gérer vos tâches efficacement.');
}
