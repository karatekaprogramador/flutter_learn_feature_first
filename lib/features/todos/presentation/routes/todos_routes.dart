import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injector.dart';
import '../cubit/todos_cubit.dart';
import '../screens/add_todo_screen.dart';

class TodosRoutes {
  static const String addTodoPath = '/add-todo';
  static const String addTodoName = 'add-todo';

  static final GoRoute addTodoRoute = GoRoute(
    path: addTodoPath,
    name: addTodoName,
    builder: (context, state) => BlocProvider.value(
      value: injector<TodosCubit>(),
      child: const AddTodoScreen(),
    ),
  );
}
