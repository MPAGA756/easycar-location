import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../data/dummy_cars.dart';

class CarProvider extends ChangeNotifier {
  final List<CarModel> _cars = List.from(dummyCars);
  String _searchQuery = '';

  List<CarModel> get cars => _cars;
  String get searchQuery => _searchQuery;

  List<CarModel> get filteredCars {
    if (_searchQuery.isEmpty) return _cars;
    return _cars.where((car) {
      final query = _searchQuery.toLowerCase();
      return car.brand.toLowerCase().contains(query) ||
          car.model.toLowerCase().contains(query) ||
          car.category.toLowerCase().contains(query);
    }).toList();
  }

  List<CarModel> getAvailableCars() {
    return _cars.where((car) => car.status == 'available').toList();
  }

  void searchCars(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addCar(CarModel car) {
    _cars.add(car);
    notifyListeners();
  }

  void updateCar(CarModel updatedCar) {
    final index = _cars.indexWhere((c) => c.id == updatedCar.id);
    if (index != -1) {
      _cars[index] = updatedCar;
      notifyListeners();
    }
  }

  void deleteCar(String id) {
    _cars.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void updateCarStatus(String carId, String status) {
    final index = _cars.indexWhere((c) => c.id == carId);
    if (index != -1) {
      _cars[index].status = status;
      notifyListeners();
    }
  }

  CarModel? getCarById(String id) {
    try {
      return _cars.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}