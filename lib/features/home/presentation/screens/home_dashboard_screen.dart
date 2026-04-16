import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../todos/todos.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: injector<TodosCubit>()..fetchTodos(),
      child: const _HomeDashboardView(),
    );
  }
}

class _HomeDashboardView extends StatelessWidget {
  const _HomeDashboardView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Dashboard')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              child: Text(
                'Menú',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_task),
              title: const Text('Agregar Tarea'),
              onTap: () {
                context.pop(); // Close drawer
                context.push(TodosRoutes.addTodoPath);
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<TodosCubit, TodosState>(
        builder: (context, state) {
          if (state.status == TodosStatus.loading && state.todos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TodosStatus.error && state.todos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Error cargando tareas: \n${state.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state.todos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 72,
                    color: theme.colorScheme.primary.withAlpha(100),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sin tareas cargadas',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Parece que tienes todo bajo control.\n¡Abre el menú lateral para agregar una nueva tarea!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TodosCubit>().fetchTodos();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.todos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: todo.description != null
                        ? Text(todo.description!)
                        : null,
                    trailing: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (val) {
                        if (val != null) {
                          context.read<TodosCubit>().toggleStatus(todo.id, val);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
