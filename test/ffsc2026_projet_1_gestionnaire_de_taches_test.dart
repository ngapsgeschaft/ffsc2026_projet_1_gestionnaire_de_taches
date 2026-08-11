import 'package:ffsc2026_projet_1_gestionnaire_de_taches/ffsc2026_projet_1_gestionnaire_de_taches.dart';
import 'package:test/test.dart';

void main() {
  test('Throw an exception for invalid choice', () {
    expect(() => getUserChoice('invalid'), throwsA(isA<ChoiceException>()));
  });

  test('Add a task', () {
    TaskManager taskManager = TaskManager();
    Task task = Task('1', 'Test Task', TaskPriority.medium);
    taskManager.addTask(task);
    expect(taskManager.tasks.length, 1);
  });

  test('Mark a task as completed', () {
    TaskManager taskManager = TaskManager();
    Task task1 = Task('1', 'Task 1', TaskPriority.low);
    Task task2 = Task('2', 'Task 2', TaskPriority.high);
    taskManager.addTask(task1);
    taskManager.addTask(task2);
    expect(task1.isCompleted, false);
    taskManager.markTaskCompleted('1');
    expect(task1.isCompleted, true);
  });

  test('Remove a task', () {
    TaskManager taskManager = TaskManager();
    Task task1 = Task('1', 'Task 1', TaskPriority.low);
    Task task2 = Task('2', 'Task 2', TaskPriority.high);
    taskManager.addTask(task1);
    taskManager.addTask(task2);

    expect(taskManager.tasks.length, 2);
    taskManager.removeTask(task1);
    expect(taskManager.tasks.length, 1);
  });

  test('Get task by ID', () {
    TaskManager taskManager = TaskManager();
    Task task1 = Task('1', 'Task 1', TaskPriority.low);
    Task task2 = Task('2', 'Task 2', TaskPriority.high);
    taskManager.addTask(task1);
    taskManager.addTask(task2);

    Task foundTask = taskManager.getTaskById('2');
    expect(foundTask.title, 'Task 2');
  });

  test('Get unmodifiable list of tasks', () {
    TaskManager taskManager = TaskManager();
    Task task1 = Task('1', 'Task 1', TaskPriority.low);
    Task task2 = Task('2', 'Task 2', TaskPriority.high);
    taskManager.addTask(task1);
    taskManager.addTask(task2);

    List<Task> unmodifiableTasks = taskManager.tasks;
    expect(unmodifiableTasks.length, 2);
    expect(
      () => unmodifiableTasks.add(Task('3', 'Task 3', TaskPriority.medium)),
      throwsUnsupportedError,
    );
  });
}
