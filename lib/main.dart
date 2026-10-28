import 'package:flutter/material.dart';
import 'widgets/today_i_learned_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TodayILearnedApp());
}

/// Standalone Flutter application showcasing the [TodayILearnedWidget].
class TodayILearnedApp extends StatelessWidget {
  const TodayILearnedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today I Learned — Micro-Knowledge Feed',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E676),
          brightness: Brightness.dark,
          surface: const Color(0xFF0F172A),
        ),
      ),
      home: const Scaffold(
        body: TodayILearnedWidget(),
      ),
    );
  }
}
