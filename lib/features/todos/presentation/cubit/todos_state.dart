import 'package:equatable/equatable.dart';
import '../../data/models/todo_model.dart';

enum TodosStatus { initial, loading, loaded, error }

class TodosState extends Equatable {
  final TodosStatus status;
  final List<TodoModel> todos;
  final String? errorMessage;
  final bool isAddingTask;
  final String? addErrorMessage;

  const TodosState({
    this.status = TodosStatus.initial,
    this.todos = const [],
    this.errorMessage,
    this.isAddingTask = false,
    this.addErrorMessage,
  });

  TodosState copyWith({
    TodosStatus? status,
    List<TodoModel>? todos,
    String? errorMessage,
    bool? isAddingTask,
    String? addErrorMessage,
    bool clearAddError = false,
  }) {
    return TodosState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      errorMessage: errorMessage ?? this.errorMessage,
      isAddingTask: isAddingTask ?? this.isAddingTask,
      addErrorMessage: clearAddError ? null : (addErrorMessage ?? this.addErrorMessage),
    );
  }

  @override
  List<Object?> get props => [status, todos, errorMessage, isAddingTask, addErrorMessage];
}
