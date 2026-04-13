import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learn_feature_first/core/di/injector.dart';
import 'package:flutter_learn_feature_first/core/widgets/widgets.dart';
import 'package:flutter_learn_feature_first/features/auth/auth.dart';
import 'package:flutter_learn_feature_first/features/home/home.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  late final AuthCubit _authCubit;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _authCubit = injector<AuthCubit>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit(AuthMode mode) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    _authCubit.submit(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: mode == AuthMode.signUp ? _nameController.text.trim() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthCubit, AuthState>(
      bloc: _authCubit,
      listener: (context, state) {
        if (state.status == AuthStatus.success && state.isAuthenticated) {
          context.go(HomeRoutes.dashboardPath);
          return;
        }

        if (state.message == null || state.message!.isEmpty) {
          return;
        }

        final isError = state.status == AuthStatus.error;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: isError
                ? theme.colorScheme.errorContainer
                : theme.colorScheme.secondaryContainer,
            content: Text(
              state.message!,
              style: TextStyle(
                color: isError
                    ? theme.colorScheme.onErrorContainer
                    : theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        );
      },
      child: Scaffold(
        body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF1F5F9),
              Color(0xFFF8FAFC),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -35,
              top: 90,
              child: _BlurBubble(
                size: 120,
                color: const Color(0xFFD8E4F0).withValues(alpha: 0.75),
              ),
            ),
            Positioned(
              left: -25,
              bottom: 110,
              child: _BlurBubble(
                size: 90,
                color: const Color(0xFFDCEEE7).withValues(alpha: 0.9),
              ),
            ),
            SafeArea(
              child: BlocBuilder<AuthCubit, AuthState>(
                bloc: _authCubit,
                builder: (context, state) {
                  final isSignIn = state.mode == AuthMode.signIn;

                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isSignIn ? 'Bienvenido' : 'Crear cuenta',
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isSignIn
                                        ? 'Inicia sesión con email y contraseña o usa OAuth con Google/GitHub.'
                                        : 'Regístrate con email y contraseña para comenzar con tus tareas.',
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  if (!isSignIn) ...[
                                    const SizedBox(height: 20),
                                    Text('Nombre', style: theme.textTheme.titleMedium),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _nameController,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (!isSignIn && (value == null || value.trim().isEmpty)) {
                                          return 'Ingresa tu nombre.';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Tu nombre',
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 20),
                                  Text(
                                    'Correo electrónico',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      final email = value?.trim() ?? '';
                                      if (email.isEmpty) {
                                        return 'Ingresa tu correo.';
                                      }
                                      if (!email.contains('@')) {
                                        return 'Ingresa un correo válido.';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'email@dominio.com',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text('Contraseña', style: theme.textTheme.titleMedium),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    validator: (value) {
                                      final password = value ?? '';
                                      if (password.isEmpty) {
                                        return 'Ingresa tu contraseña.';
                                      }
                                      if (password.length < 6) {
                                        return 'Debe tener al menos 6 caracteres.';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isSignIn) ...[
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: const Text('Olvidé mi contraseña'),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 6),
                                  PrimaryButtonsKarateka(
                                    onPressed: state.isLoading ? () {} : () => _submit(state.mode),
                                    text: Text(
                                      state.isLoading
                                          ? 'Procesando...'
                                          : (isSignIn ? 'Iniciar sesión' : 'Crear cuenta'),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: state.isLoading
                                          ? null
                                          : () => _authCubit.signInWithOAuth(AuthOAuthProvider.google),
                                      icon: const Icon(Icons.g_mobiledata_rounded),
                                      label: const Text('Continuar con Google'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: state.isLoading
                                          ? null
                                          : () => _authCubit.signInWithOAuth(AuthOAuthProvider.github),
                                      icon: const Icon(Icons.code_rounded),
                                      label: const Text('Continuar con GitHub'),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.center,
                                    child: TextButton(
                                      onPressed: state.isLoading ? null : _authCubit.toggleMode,
                                      child: Text(
                                        isSignIn
                                            ? '¿No tienes cuenta? Crear una'
                                            : '¿Ya tienes cuenta? Iniciar sesión',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _BlurBubble extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurBubble({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
