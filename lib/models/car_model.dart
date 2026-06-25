class CarModel {
  final String id;
  final String brand;
  final String model;
  final int year;
  final double pricePerDay;
  String status;
  final String imageUrl;
  final String description;
  final String category;

  CarModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.pricePerDay,
    required this.status,
    required this.imageUrl,
    required this.description,
    required this.category,
  });

  bool get isAvailable => status == 'available';

  String get fullName => '$brand $model';

  CarModel copyWith({
    String? id,
    String? brand,
    String? model,
    int? year,
    double? pricePerDay,
    String? status,
    String? imageUrl,
    String? description,
    String? category,
  }) {
    return CarModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      category: category ?? this.category,
    );
  }
}