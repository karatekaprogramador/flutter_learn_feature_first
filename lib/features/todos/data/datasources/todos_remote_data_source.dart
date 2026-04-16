import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../models/todo_model.dart';

class TodosRemoteDataSource {
  final Dio _dio;
  final AuthCubit _authCubit; // Injected for getting the dynamic OAuth token

  TodosRemoteDataSource({
    required Dio dio,
    required AuthCubit authCubit,
  })  : _dio = dio,
        _authCubit = authCubit;

  Options get _options {
    final token = _authCubit.state.accessToken;
    final headers = <String, dynamic>{};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return Options(headers: headers);
  }

  Future<List<TodoModel>> getTodos() async {
    final endpoint = '${AppConfig.insforgeBaseUrl}/api/database/records/todos?order=created_at.desc';
    try {
      final response = await _dio.get<List<dynamic>>(
        endpoint,
        options: _options,
      );
      
      if (response.data == null) return [];
      
      return response.data!
          .cast<Map<String, dynamic>>()
          .map((e) => TodoModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch todos: ${e.message}');
    }
  }

  Future<TodoModel> createTodo(String title, String? description) async {
    final endpoint = '${AppConfig.insforgeBaseUrl}/api/database/records/todos';
    try {
      final response = await _dio.post<List<dynamic>>(
        endpoint,
        data: {
          'title': title,
          'description': description,
        },
        options: _options.copyWith(
          headers: {
            ...?_options.headers,
            'Prefer': 'return=representation', // Le dice a PostgREST que devuelva el objecto insertado
          },
        ),
      );

      return TodoModel.fromJson(response.data!.first as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to create todo: ${e.message}');
    }
  }

  Future<void> toggleTodoStatus(String id, bool updatedStatus) async {
    final endpoint = '${AppConfig.insforgeBaseUrl}/api/database/records/todos?id=eq.$id';
    try {
      await _dio.patch(
        endpoint,
        data: {
          'is_completed': updatedStatus,
        },
        options: _options,
      );
    } on DioException catch (e) {
      throw Exception('Failed to update todo: ${e.message}');
    }
  }
}
