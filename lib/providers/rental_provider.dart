import 'package:flutter/material.dart';
import '../models/rental_model.dart';
import '../data/dummy_rentals.dart';

class RentalProvider extends ChangeNotifier {
final List<RentalModel> _rentals = List.from(dummyRentals);
  List<RentalModel> get rentals => _rentals;

  List<RentalModel> getAllRentals() {
    return _rentals;
  }

  List<RentalModel> getUserRentals(String userId) {
    return _rentals.where((r) => r.userId == userId).toList();
  }

  void rentCar(
    String carId,
    String userId,
    DateTime startDate,
    DateTime endDate,
    double pricePerDay,
  ) {
    final total = calculateTotal(startDate, endDate, pricePerDay);
    final newRental = RentalModel(
      id: 'r${_rentals.length + 1}',
      carId: carId,
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      totalPrice: total,
      status: 'active',
    );
    _rentals.add(newRental);
    notifyListeners();
  }

  void returnCar(String rentalId) {
    final index = _rentals.indexWhere((r) => r.id == rentalId);
    if (index != -1) {
      _rentals[index].status = 'completed';
      notifyListeners();
    }
  }

  double calculateTotal(
    DateTime startDate,
    DateTime endDate,
    double pricePerDay,
  ) {
    final days = endDate.difference(startDate).inDays;
    if (days <= 0) return pricePerDay;
    return days * pricePerDay;
  }

  int getTotalActiveRentals() {
    return _rentals.where((r) => r.status == 'active').length;
  }
}