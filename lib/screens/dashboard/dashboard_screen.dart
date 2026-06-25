import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/car_provider.dart';
import '../../providers/rental_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final carProvider = context.watch<CarProvider>();
    final rentalProvider = context.watch<RentalProvider>();

    final totalCars = carProvider.cars.length;
    final availableCars = carProvider.getAvailableCars().length;
    final rentedCars =
        carProvider.cars.where((c) => c.status == 'rented').length;
    final totalRentals = rentalProvider.getAllRentals().length;

    final today =
        DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour, ${auth.currentUser?.name ?? ''} 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _capitalize(today),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.15,
                children: [
                  DashboardCard(
                    title: 'Total voitures',
                    value: '$totalCars',
                    icon: Icons.directions_car_rounded,
                    color: AppColors.primary,
                  ),
                  DashboardCard(
                    title: 'Disponibles',
                    value: '$availableCars',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                  ),
                  DashboardCard(
                    title: 'En location',
                    value: '$rentedCars',
                    icon: Icons.car_rental_rounded,
                    color: AppColors.warning,
                  ),
                  DashboardCard(
                    title: 'Locations totales',
                    value: '$totalRentals',
                    icon: Icons.history_rounded,
                    color: AppColors.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              CustomButton(
                label: 'Voir le catalogue →',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.cars);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
