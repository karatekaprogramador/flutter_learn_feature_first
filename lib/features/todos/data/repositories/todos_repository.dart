import '../datasources/todos_remote_data_source.dart';
import '../models/todo_model.dart';

class TodosRepository {
  final TodosRemoteDataSource _remoteDataSource;

  TodosRepository(this._remoteDataSource);

  Future<List<TodoModel>> getTodos() => _remoteDataSource.getTodos();

  Future<TodoModel> createTodo({required String title, String? description}) =>
      _remoteDataSource.createTodo(title, description);

  Future<void> toggleTodoStatus(String id, bool status) =>
      _remoteDataSource.toggleTodoStatus(id, status);
}
