import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_learn_feature_first/core/widgets/widgets.dart';
import 'package:flutter_learn_feature_first/features/auth/auth.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingStep> _steps = const [
    _OnboardingStep(
      icon: Icons.checklist_rounded,
      title: 'Organiza tu día con calma',
      description:
          'Convierte tus ideas en tareas simples y claras para mantener el foco sin estrés.',
    ),
    _OnboardingStep(
      icon: Icons.schedule_rounded,
      title: 'Prioridades en un vistazo',
      description:
          'Define qué hacer primero y sigue tu ritmo con una experiencia limpia y sin ruido.',
    ),
    _OnboardingStep(
      icon: Icons.lock_person_rounded,
      title: 'Tu progreso, siempre seguro',
      description:
          'Accede a tu cuenta y mantiene tus pendientes sincronizados en cualquier momento.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToLogin() {
    context.go(AuthRoutes.loginPath);
  }

  void _nextStep() {
    if (_currentPage == _steps.length - 1) {
      _goToLogin();
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEEF2F7),
              Color(0xFFF8FAFC),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -60,
              child: _SoftCircle(
                size: 220,
                color: const Color(0xFFDEE7F2).withValues(alpha: 0.75),
              ),
            ),
            Positioned(
              bottom: -90,
              left: -40,
              child: _SoftCircle(
                size: 190,
                color: const Color(0xFFDCEDE8).withValues(alpha: 0.8),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _goToLogin,
                        child: const Text('Saltar'),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: _steps.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final step = _steps[index];
                          return _OnboardingPage(step: step);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _steps.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButtonsKarateka(
                      onPressed: _nextStep,
                      text: Text(
                        _currentPage == _steps.length - 1
                            ? 'Empezar'
                            : 'Siguiente',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _goToLogin,
                      child: const Text('Ya tengo cuenta'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingStep step;

  const _OnboardingPage({required this.step});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            step.icon,
            size: 52,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          step.title,
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          step.description,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _OnboardingStep {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _SoftCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _SoftCircle({required this.size, required this.color});

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
