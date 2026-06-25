import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../utils/app_constants.dart';

/// Tiroir de navigation principal.
/// Header façon "carnet de bord de garage" : couleur primaire pleine,
/// avatar rond cerclé, infos utilisateur.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              accountName: Text(
                auth.currentUser?.name ?? 'Invité',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              accountEmail: Text(auth.currentUser?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.surface,
                child: Text(
                  (auth.currentUser?.name.isNotEmpty == true)
                      ? auth.currentUser!.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _DrawerItem(
              icon: Icons.dashboard_rounded,
              label: 'Tableau de bord',
              route: AppRoutes.dashboard,
              currentRoute: currentRoute,
            ),
            _DrawerItem(
              icon: Icons.directions_car_filled_rounded,
              label: 'Catalogue',
              route: AppRoutes.cars,
              currentRoute: currentRoute,
            ),
            _DrawerItem(
              icon: Icons.history_rounded,
              label: 'Historique',
              route: AppRoutes.history,
              currentRoute: currentRoute,
            ),
            _DrawerItem(
              icon: Icons.info_outline_rounded,
              label: 'À propos',
              route: AppRoutes.about,
              currentRoute: currentRoute,
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: AppColors.divider),
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.error),
              title: const Text(
                'Déconnexion',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                context.read<AuthProvider>().logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 4),
              child: Text(
                '${AppConstants.appName} · v${AppConstants.appVersion}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final String? currentRoute;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentRoute == route;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: isActive ? AppColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          leading: Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.secondary,
          ),
          title: Text(
            label,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            if (!isActive) {
              Navigator.pushNamed(context, route);
            }
          },
        ),
      ),
    );
  }
}
