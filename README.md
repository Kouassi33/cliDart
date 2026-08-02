# Gestionnaire de tâches – CLI (Dart pur)

Application en ligne de commande pour gérer une liste de tâches, développée en **Dart** sans Flutter.  
Elle respecte les principes de la programmation orientée objet et utilise la persistance JSON.

---

## Fonctionnalités

- **Ajouter une tâche** : titre, priorité (`low` / `medium` / `high`), date limite optionnelle.
- **Lister les tâches** : affichage trié par priorité.
- **Marquer une tâche comme terminée**.
- **Supprimer une tâche**.
- **Persistance automatique** : toutes les données sont sauvegardées dans un fichier `tasks.json` (créé à la racine).

---

## Architecture technique

### Concepts OOP utilisés

- **Classe abstraite** `Task` : définit les attributs communs et les méthodes (ex: `isOverdue`, `compareTo`, `toJson`). Elle ne peut pas être instanciée directement.
- **Héritage** : `faibleTask`,`normalTask`et `UrgentTask` qui étend `Task` .
- **Interface** : `Serializable` (implémentée par `Task`) pour forcer la sérialisation JSON.
- **Génériques** : `Repository<T extends Task>` permet de réutiliser la logique de persistance pour tout type de tâche.
- **Exceptions personnalisées** : `TaskException`, `TaskNotFoundException`, `InvalidPriorityException`, etc.
- **Tests unitaires** : ≥ 5 tests avec le package `test`.

---

## Installation

1. **Vérifier** que Dart SDK est installé (`dart --version` ≥ 2.19).
2. **cloner** le projet Dart depuis le repository https://github.com/Kouassi33/cliDart :
   ```bash
   git clone git@github.com:Kouassi33/cliDart.gitgit
   cd cliDart

3. **Ajouter** la dependance `test` dans pubspec.yaml 
    ```bash
    dev_dependencies:
    test: ^1.24.0

4. **installer** la dependance
    ```bash
    dart pub get

## Executer le projet

`dart run main.dart`

un menu s'affiche :

=== Gestionnaire de tâches ===

Menu:
1. Ajouter une tâches
2. Lister les tâches
3. Marquer une tâche comme terminée
4. Supprimer une tâche
5. Quitter

Choisissez une option: 

## Execution du test

`dart test`