import 'dart:io';

int calculate() {
  return 6 * 7;
}

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
