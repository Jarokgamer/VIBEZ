import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibez/screens/home_screen.dart';
import 'package:vibez/providers/game_provider.dart';
import 'package:vibez/providers/player_provider.dart';
import 'package:vibez/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ],
      child: MaterialApp(
        title: 'VIBEZ',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}