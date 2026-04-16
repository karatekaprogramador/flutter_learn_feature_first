import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/todos_cubit.dart';
import '../cubit/todos_state.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await context.read<TodosCubit>().addTodo(
          _titleController.text.trim(),
          _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        );

    if (success && mounted) {
      context.pop(); // Volver al inicio despues de crear
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodosCubit, TodosState>(
      listener: (context, state) {
        if (state.addErrorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.addErrorMessage}')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Agregar Tarea'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título de la tarea',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'El título es obligatorio';
                      return null;
                    },
                    enabled: !state.isAddingTask,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción (Opcional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    enabled: !state.isAddingTask,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state.isAddingTask ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: state.isAddingTask
                        ? const CircularProgressIndicator()
                        : const Text('Guardar Tarea'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
