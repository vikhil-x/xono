import 'package:flutter/material.dart';
import 'ui/bottom_nav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/search_page.dart';

void main() {
  runApp(ProviderScope(child: const XonoApp()));
}

class XonoApp extends StatefulWidget {
  const XonoApp({super.key});

  @override
  State<XonoApp> createState() => _XonoAppState();
}

class _XonoAppState extends State<XonoApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool value) {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XONO',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurpleAccent,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'XONO',
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final bool isDark;
  final void Function(bool) onToggleTheme;

  const MyHomePage({
    super.key,
    required this.title,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Switch(
            value: isDark,
            onChanged: onToggleTheme,
          ),
          SizedBox(
            width: 8,
          )
        ],
      ),
      body: Center(
        child: const SearchPage(),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
