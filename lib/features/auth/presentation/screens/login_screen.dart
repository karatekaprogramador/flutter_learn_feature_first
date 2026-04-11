import 'package:flutter/material.dart';
import 'package:flutter_learn_feature_first/core/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login listo. Conecta aquí tu servicio de autenticación.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
              child: Center(
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
                              Text('Bienvenido', style: theme.textTheme.headlineMedium),
                              const SizedBox(height: 8),
                              Text(
                                'Ingresa para administrar tus tareas con una experiencia simple y clara.',
                                style: theme.textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 24),
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
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Olvidé mi contraseña'),
                                ),
                              ),
                              const SizedBox(height: 6),
                              PrimaryButtonsKarateka(
                                onPressed: _submit,
                                text: const Text('Iniciar sesión'),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: const Text('Continuar como invitado'),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('¿No tienes cuenta? Crear una'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
