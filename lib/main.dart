import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/car_provider.dart';
import 'providers/rental_provider.dart';
import 'utils/app_colors.dart';
import 'utils/app_constants.dart';

// Screens — à créer par le Frontend
// import 'screens/splash_screen.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/register_screen.dart';
// import 'screens/dashboard/dashboard_screen.dart';
// import 'screens/cars/cars_screen.dart';
// import 'screens/cars/car_detail_screen.dart';
// import 'screens/cars/add_edit_car_screen.dart';
// import 'screens/rentals/rental_screen.dart';
// import 'screens/rentals/history_screen.dart';
// import 'screens/about/about_screen.dart';

void main() {
  runApp(const EasyCarApp());
}

class EasyCarApp extends StatelessWidget {
  const EasyCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => RentalProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            error: AppColors.error,
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        // Route initiale temporaire — sera remplacée par SplashScreen
        home: const _TempHome(),
        routes: {
          // AppRoutes.splash: (context) => const SplashScreen(),
          // AppRoutes.login: (context) => const LoginScreen(),
          // AppRoutes.register: (context) => const RegisterScreen(),
          // AppRoutes.dashboard: (context) => const DashboardScreen(),
          // AppRoutes.cars: (context) => const CarsScreen(),
          // AppRoutes.history: (context) => const HistoryScreen(),
          // AppRoutes.about: (context) => const AboutScreen(),
        },
      ),
    );
  }
}

// Écran temporaire pour tester que le Backend fonctionne
class _TempHome extends StatelessWidget {
  const _TempHome();

  @override
  Widget build(BuildContext context) {
    final carProvider = context.watch<CarProvider>();
    final rentalProvider = context.watch<RentalProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('EasyCar — Backend OK ✅')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_car, size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text(
              'EasyCar Location',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${carProvider.cars.length} voitures chargées ✅'),
            Text('${rentalProvider.getAllRentals().length} locations chargées ✅'),
            const SizedBox(height: 8),
            const Text(
              'Backend prêt — En attente du Frontend',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}