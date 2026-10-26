import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import '../shared/widgets/bunny_mascot.dart';
import 'theme/app_colors.dart';
import '../l10n/app_localizations.dart';

class RoutineBunnyApp extends ConsumerStatefulWidget {
  const RoutineBunnyApp({super.key});

  @override
  ConsumerState<RoutineBunnyApp> createState() => _RoutineBunnyAppState();
}

class _RoutineBunnyAppState extends ConsumerState<RoutineBunnyApp> {
  bool _showSplash = true;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(ref.read(preferencesStoreProvider));
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return MaterialApp(
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
          home: const _SplashPage());
    }
    final preferences = ref.watch(preferencesStoreProvider);
    return MaterialApp.router(
      title: 'RoutineBunny',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.forName(preferences.theme),
      supportedLocales: const [
        Locale('en'),
        Locale('ja'),
        Locale('zh'),
        Locale('ko')
      ],
      locale: Locale(preferences.language),
      /*
        '日本語' => const Locale('ja'),
        '中文' => const Locale('zh'),
        '한국어' => const Locale('ko'),
        _ => const Locale('en'),
      },
      */
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: _router,
      builder: (context, child) => child ?? const SizedBox(),
    );
  }
}

class _SplashPage extends StatefulWidget {
  const _SplashPage();

  @override
  State<_SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<_SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100));
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
            child: ScaleTransition(
                scale: _scale,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const BunnyMascot(size: 154, expression: 'happy'),
                  const SizedBox(height: 8),
                  Text('RoutineBunny',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: AppColors.rosePink,
                              fontSize: 28,
                              fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  const Text('A softer way to remember your day',
                      style: TextStyle(color: AppColors.mutedBrown)),
                ]))),
      );
}
