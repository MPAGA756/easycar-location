import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/car_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/rental_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_button.dart';

class RentalScreen extends StatefulWidget {
  final CarModel car;

  const RentalScreen({super.key, required this.car});

  @override
  State<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isConfirming = false;

  final _dateFormat = DateFormat('dd/MM/yyyy');

  double? get _total {
    if (_startDate == null || _endDate == null) return null;
    if (_endDate!.isBefore(_startDate!)) return null;
    return context.read<RentalProvider>().calculateTotal(
          _startDate!,
          _endDate!,
          widget.car.pricePerDay,
        );
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choisissez d\'abord une date de début'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate!.add(const Duration(days: 1)),
      firstDate: _startDate!.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _confirmRental() async {
    if (_startDate == null || _endDate == null || _total == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner des dates valides'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isConfirming = true);
    final auth = context.read<AuthProvider>();

    context.read<RentalProvider>().rentCar(
          widget.car.id,
          auth.currentUser!.id,
          _startDate!,
          _endDate!,
        );

    if (!mounted) return;
    setState(() => _isConfirming = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 30),
        ),
        title: const Text(
          'Location confirmée avec succès !',
          textAlign: TextAlign.center,
        ),
        content: Text(
          '${widget.car.brand} ${widget.car.model} est réservée du '
          '${_dateFormat.format(_startDate!)} au ${_dateFormat.format(_endDate!)}.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              label: 'Retour au catalogue',
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) => route.settings.name == AppRoutes.cars,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Louer une voiture'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Résumé voiture
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: _buildThumbnail(car),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${car.brand} ${car.model}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${car.pricePerDay.toStringAsFixed(0)} DA/jour',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Période de location',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _DatePickerTile(
                label: 'Date de début',
                date: _startDate,
                dateFormat: _dateFormat,
                onTap: _pickStartDate,
              ),
              const SizedBox(height: 12),
              _DatePickerTile(
                label: 'Date de fin',
                date: _endDate,
                dateFormat: _dateFormat,
                onTap: _pickEndDate,
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _total != null
                    ? Container(
                        key: const ValueKey('total'),
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Prix total estimé',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${_total!.toStringAsFixed(0)} DA',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
              const SizedBox(height: 28),
              CustomButton(
                label: 'Confirmer la location',
                isLoading: _isConfirming,
                onPressed: _confirmRental,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(CarModel car) {
    if (car.imageUrl.isEmpty) {
      return Container(
        color: AppColors.secondaryLight,
        child: const Icon(Icons.directions_car_rounded, color: AppColors.secondary),
      );
    }
    if (car.imageUrl.startsWith('http')) {
      return Image.network(
        car.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: AppColors.secondaryLight,
          child: const Icon(Icons.directions_car_rounded, color: AppColors.secondary),
        ),
      );
    }
    return Image.asset(
      car.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.secondaryLight,
        child: const Icon(Icons.directions_car_rounded, color: AppColors.secondary),
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  const _DatePickerTile({
    required this.label,
    required this.date,
    required this.dateFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, color: AppColors.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date != null ? dateFormat.format(date!) : 'Sélectionner',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: date != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
