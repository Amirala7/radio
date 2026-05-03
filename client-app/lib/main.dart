import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/auth/auth_service.dart';
import 'core/network/cloud_functions_client.dart';
import 'core/theme/app_spacing.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_typography.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final auth = AuthService();
  await auth.ensureSignedIn();
  runApp(RadioApp(authService: auth));
}

class RadioApp extends StatelessWidget {
  const RadioApp({required this.authService, super.key});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CloudFunctionsClient>(create: (_) => CloudFunctionsClient()),
        Provider<AuthService>.value(value: authService),
      ],
      child: MaterialApp(
        title: 'Radio',
        theme: AppTheme.light,
        home: const _BootHome(),
      ),
    );
  }
}

class _BootHome extends StatelessWidget {
  const _BootHome();

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('raDio', style: AppTypography.wordmark),
              const SizedBox(height: AppSpacing.xl),
              const Text('ALL STATIONS', style: AppTypography.sectionLabel),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                user == null ? 'Not signed in' : 'Signed in as ${user.uid}',
                style: AppTypography.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
