import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/car_model.dart';
import '../../providers/car_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddEditCarScreen extends StatefulWidget {
  final CarModel? car;

  const AddEditCarScreen({super.key, this.car});

  @override
  State<AddEditCarScreen> createState() => _AddEditCarScreenState();
}

class _AddEditCarScreenState extends State<AddEditCarScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  String _category = 'berline';
  bool _isSaving = false;

  bool get _isEditMode => widget.car != null;

  final _categories = const ['berline', 'suv', 'citadine'];

  @override
  void initState() {
    super.initState();
    final car = widget.car;
    _brandController = TextEditingController(text: car?.brand ?? '');
    _modelController = TextEditingController(text: car?.model ?? '');
    _yearController =
        TextEditingController(text: car != null ? '${car.year}' : '');
    _priceController = TextEditingController(
        text: car != null ? car.pricePerDay.toString() : '');
    _descriptionController =
        TextEditingController(text: car?.description ?? '');
    _imageUrlController = TextEditingController(text: car?.imageUrl ?? '');
    if (car != null && _categories.contains(car.category)) {
      _category = car.category;
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final carProvider = context.read<CarProvider>();

    if (!_isEditMode) {
      final newCar = CarModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        pricePerDay: double.parse(_priceController.text.trim()),
        status: 'available',
        imageUrl: _imageUrlController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
      );
      carProvider.addCar(newCar);
    } else {
      final updatedCar = CarModel(
        id: widget.car!.id,
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        pricePerDay: double.parse(_priceController.text.trim()),
        status: widget.car!.status,
        imageUrl: _imageUrlController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
      );
      carProvider.updateCar(updatedCar);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Modifier la voiture' : 'Ajouter une voiture'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  label: 'Marque',
                  controller: _brandController,
                  prefixIcon: Icons.branding_watermark_outlined,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'Modèle',
                  controller: _modelController,
                  prefixIcon: Icons.directions_car_outlined,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Année',
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.calendar_today_outlined,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Requis';
                          final year = int.tryParse(v.trim());
                          if (year == null) return 'Invalide';
                          if (year < 1950 || year > 2100) return 'Invalide';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        label: 'Prix / jour',
                        controller: _priceController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        prefixIcon: Icons.payments_outlined,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Requis';
                          final price = double.tryParse(v.trim());
                          if (price == null || price <= 0) return 'Invalide';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: InputDecoration(
                    labelText: 'Catégorie',
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.divider, width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.divider, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 1.8),
                    ),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c[0].toUpperCase() + c.substring(1)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 4,
                  prefixIcon: Icons.description_outlined,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'URL de l\'image',
                  controller: _imageUrlController,
                  hint: 'assets/cars/xxx.jpg ou https://...',
                  prefixIcon: Icons.image_outlined,
                ),
                const SizedBox(height: 28),
                CustomButton(
                  label: 'Enregistrer',
                  isLoading: _isSaving,
                  onPressed: _handleSave,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
