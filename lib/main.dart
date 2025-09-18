import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/supabase_config.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/farmer_provider.dart';
import 'providers/task_provider.dart';
import 'screens/splash_screen.dart';
import 'services/storage_service.dart';
import 'utils/app_colors.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock orientation to portrait for optimal mobile UX
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  try {
    // Initialize services
    await StorageService.initialize();
    await SupabaseConfig.initialize();
  } catch (e) {
    // If initialization fails, the app will still run but show appropriate errors
    print('Initialization error: $e');
  }
  
  runApp(const BharathIntelligenceApp());
}

class BharathIntelligenceApp extends StatelessWidget {
  const BharathIntelligenceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FarmerProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: AppColors.primarySwatch,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.buttonText,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: AppConstants.textSizeTitle,
              fontWeight: FontWeight.w600,
              color: AppColors.buttonText,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.buttonText,
              elevation: AppConstants.cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingMedium,
            ),
          ),
          cardTheme: CardTheme(
            color: AppColors.cardBackground,
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          dividerColor: AppColors.divider,
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppConstants.textSizeHeading,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppConstants.textSizeTitle,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppConstants.textSizeLarge,
            ),
            bodyMedium: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppConstants.textSizeMedium,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}