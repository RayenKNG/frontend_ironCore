import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_theme.dart';
import '../catalog/screens/catalog_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _barAnim;
  String _statusText = 'Initializing Firebase...';

  final List<String> _statuses = [
    'Initializing Firebase...',
    'Checking auth token...',
    'Loading catalog data...',
    'Ready!',
  ];

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _barAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.forward();

    // Cycle status texts
    for (int i = 0; i < _statuses.length; i++) {
      Future.delayed(Duration(milliseconds: i * 600), () {
        if (mounted) setState(() => _statusText = _statuses[i]);
      });
    }

    // Navigate after splash
    Future.delayed(const Duration(milliseconds: 2800), _navigate);
  }

  void _navigate() {
    final user = FirebaseAuth.instance.currentUser;
    final next = user != null
        ? const CatalogScreen()
        : const LoginScreen();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => next,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.fitness_center,
                  color: Colors.white, size: 44),
            ),
            const SizedBox(height: 20),

            // Brand name
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
                children: [
                  TextSpan(
                    text: 'IRON',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'CORE',
                    style: TextStyle(color: AppTheme.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'GYM EQUIPMENT MARKETPLACE',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textHint,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 48),

            // Loading bar
            SizedBox(
              width: 200,
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _barAnim,
                    builder: (_, __) => ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: _barAnim.value,
                        backgroundColor: AppTheme.bgCard,
                        color: AppTheme.primary,
                        minHeight: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _statusText,
                      key: ValueKey(_statusText),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textHint,
                        fontFamily: 'Monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
