class RentalModel {
  final String id;
  final String carId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  String status;

  RentalModel({
    required this.id,
    required this.carId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
  });

  bool get isActive => status == 'active';

  int get durationDays => endDate.difference(startDate).inDays;

  RentalModel copyWith({
    String? id,
    String? carId,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    double? totalPrice,
    String? status,
  }) {
    return RentalModel(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
    );
  }
}