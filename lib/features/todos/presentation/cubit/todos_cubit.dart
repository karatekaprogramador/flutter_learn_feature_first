import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/todo_model.dart';
import '../../data/repositories/todos_repository.dart';
import 'todos_state.dart';

class TodosCubit extends Cubit<TodosState> {
  final TodosRepository _repository;

  TodosCubit(this._repository) : super(const TodosState());

  void fetchTodos() async {
    emit(state.copyWith(status: TodosStatus.loading));
    try {
      final todos = await _repository.getTodos();
      emit(state.copyWith(
        status: TodosStatus.loaded,
        todos: todos,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TodosStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<bool> addTodo(String title, String? description) async {
    emit(state.copyWith(isAddingTask: true, clearAddError: true));
    try {
      final newTodo = await _repository.createTodo(
        title: title,
        description: description,
      );
      
      final updatedTodos = List<TodoModel>.from(state.todos)..insert(0, newTodo);
      
      emit(state.copyWith(
        isAddingTask: false,
        todos: updatedTodos,
      ));
      return true; // Éxito
    } catch (e) {
      emit(state.copyWith(
        isAddingTask: false,
        addErrorMessage: e.toString(),
      ));
      return false;
    }
  }

  Future<void> toggleStatus(String id, bool updatedStatus) async {
    try {
      // Optimistic update
      final idx = state.todos.indexWhere((t) => t.id == id);
      if (idx == -1) return;
      
      final currentList = List<TodoModel>.from(state.todos);
      final oldTodo = currentList[idx];
      currentList[idx] = TodoModel(
        id: oldTodo.id,
        title: oldTodo.title,
        description: oldTodo.description,
        isCompleted: updatedStatus,
        userId: oldTodo.userId,
        createdAt: oldTodo.createdAt,
      );
      
      emit(state.copyWith(todos: currentList));

      // Network update
      await _repository.toggleTodoStatus(id, updatedStatus);
    } catch (e) {
      // Revert in case of failure
      fetchTodos();
    }
  }
}
