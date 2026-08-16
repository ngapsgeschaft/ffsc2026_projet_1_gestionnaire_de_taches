import 'package:ffsc2026_projet_1_gestionnaire_de_taches/ffsc2026_projet_1_gestionnaire_de_taches.dart';
import 'package:test/test.dart';

void main() {
  test('Throw an exception for invalid choice', () {
    expect(() => getUserChoice('invalid'), throwsA(isA<ChoiceException>()));
  });

  test('Add a task in the repository', () {
    TaskRepository taskRepository = TaskRepository();
    Task task = Task(
      id: '1',
      title: 'Test Task',
      priority: TaskPriority.medium,
      isCompleted: false,
    );
    taskRepository.add(task);
    expect(taskRepository.getAll().length, 1);
  });

  test('Mark a task in the repository as completed', () {
    TaskRepository taskRepository = TaskRepository();
    Task task = Task(
      id: '1',
      title: 'Test Task 1',
      priority: TaskPriority.medium,
      isCompleted: false,
    );
    taskRepository.add(task);
    expect(task.isCompleted, false);
    Task taskCompleted = task.copyWith(isCompleted: true);
    taskRepository.update(taskCompleted);
    expect(taskRepository.getById(taskCompleted.id).isCompleted, true);
  });

  test('Remove a task from the repository', () {
    TaskRepository taskRepository = TaskRepository();
    Task task1 = Task(
      id: '1',
      title: 'Test Task 1',
      priority: TaskPriority.medium,
      isCompleted: false,
    );
    Task task2 = Task(
      id: '2',
      title: 'Test Task 2',
      priority: TaskPriority.medium,
      isCompleted: false,
    );
    taskRepository.add(task1);
    taskRepository.add(task2);

    expect(taskRepository.getAll().length, 2);
    taskRepository.delete(task2.id);
    expect(taskRepository.getAll().length, 1);
  });

  test('Get task by ID', () {
    TaskRepository taskRepository = TaskRepository();
    Task task1 = Task(
      id: '1',
      title: 'Test Task 1',
      priority: TaskPriority.medium,
      isCompleted: false,
    );
    Task task2 = Task(
      id: '2',
      title: 'Test Task 2',
      priority: TaskPriority.medium,
      isCompleted: false,
    );
    taskRepository.add(task1);
    taskRepository.add(task2);

    Task foundTask = taskRepository.getById('2');
    expect(foundTask.title, 'Test Task 2');
  });

  test('Get unmodifiable list of tasks', () {
    TaskRepository taskRepository = TaskRepository();
    Task task1 = Task(
      id: '1',
      title: 'Test Task 1',
      priority: TaskPriority.medium,
      isCompleted: false,
    );
    Task task2 = Task(
      id: '2',
      title: 'Test Task 2',
      priority: TaskPriority.medium,
      isCompleted: false,
    );
    taskRepository.add(task1);
    taskRepository.add(task2);

    List<Task> unmodifiableTasks = taskRepository.getAll();
    expect(unmodifiableTasks.length, 2);
    expect(
      () => unmodifiableTasks.add(
        Task(
          id: '2',
          title: 'Test Task 2',
          priority: TaskPriority.medium,
          isCompleted: false,
        ),
      ),
      throwsUnsupportedError,
    );
  });
}
