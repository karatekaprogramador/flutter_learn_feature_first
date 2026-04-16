import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../routes/auth_routes.dart';
import '../../../../features/home/presentation/routes/home_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class AuthCallbackScreen extends StatelessWidget {
  final String? error;
  final String? errorDescription;
  final String? rawUri;

  const AuthCallbackScreen({
    super.key,
    this.error,
    this.errorDescription,
    this.rawUri,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return _buildErrorScreen(context, error!, errorDescription);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Autenticación')),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.loading ||
              state.status == AuthStatus.initial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generando credenciales seguras...'),
                ],
              ),
            );
          }

          if (state.status == AuthStatus.error) {
            return _buildErrorScreen(
              context,
              state.message ?? 'Ocurrió un error inesperado',
              null,
            );
          }

          if (state.status == AuthStatus.success && state.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '¡Autenticación exitosa!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go(HomeRoutes.dashboardPath),
                    child: const Text('Entrar al Inicio (Home)'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text(
                    'Procesando autenticación... esperé un parámetro de acceso pero no procedió automáticamente.',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Debug URI Recibido:\n${rawUri ?? "Nulo"}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Estado Auth: ${state.status.name} | Auth: ${state.isAuthenticated} | Token: ${state.accessToken != null}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorScreen(
    BuildContext context,
    String? errorMsg,
    String? desc,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error de Autenticación')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: $errorMsg',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (desc != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(desc, textAlign: TextAlign.center),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AuthRoutes.loginPath),
              child: const Text('Volver al Login'),
            ),
          ],
        ),
      ),
    );
  }
}
