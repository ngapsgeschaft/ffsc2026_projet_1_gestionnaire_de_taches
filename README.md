# Gestionnaire de tâches CLI

Application de gestion de tâches en Dart pur, sans Flutter.

## Objectif
Le projet permet de :
- ajouter une tâche avec un titre, une priorité (`low`, `medium`, `high`) et une date limite optionnelle ;
- lister les tâches triées par priorité ou par date ;
- marquer une tâche comme terminée ;
- supprimer une tâche ;
- conserver les données dans un fichier JSON local.

## Fonctionnalités obligatoires
- ajout d'une tâche ;
- affichage de toutes les tâches ;
- tri par priorité ou par date ;
- marquage comme terminée ;
- suppression ;
- persistance locale en JSON ;
- utilisation des classes abstraites / héritage ;
- au moins une interface ;
- utilisation des génériques ;
- exceptions personnalisées ;
- tests unitaires avec `package:test`.

## Structure du projet
- `bin/` : point d'entrée de l'application CLI ;
- `lib/` : logique métier, repository, modèles et gestion du stockage ;
- `test/` : tests unitaires.

## Lancement
Depuis la racine du projet, exécutez :

```bash
dart run bin/ffsc2026_projet_1_gestionnaire_de_taches.dart
```

## Exécution des tests

```bash
dart test
```

## Exemple de flux d'utilisation
1. choisir l'option de création d'une tâche ;
2. entrer le titre, la priorité et éventuellement la date limite ;
3. lister les tâches ;
4. marquer une tâche comme terminée ;
5. supprimer une tâche si nécessaire.

## Persistance des données
Les tâches sont enregistrées dans un fichier JSON local du projet (par exemple `tasks.json`).

## Remarques
Le projet respecte le pattern repository pour séparer la logique de gestion des tâches de la persistance, et applique une approche simple et pédagogique pour un apprentissage en Dart CLI.
