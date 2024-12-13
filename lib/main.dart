import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/config/router/app_router.dart';
import 'package:showroom_maqueta/config/theme/app_theme.dart';
import 'package:showroom_maqueta/providers/theme_provider.dart';
import 'providers/item_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ItemProvider(),),
        ChangeNotifierProvider(create: (_) => ThemeProvider(),),
      ],
      child: const MyApp(),
    )
  );

} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appTheme = AppTheme(selectedColor: themeProvider.selectedColor);
    return MaterialApp.router(
      theme: appTheme.getTheme(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('es', 'UY'), // Spanish
      ],
      routerConfig: appRouter,
    );
  }
}