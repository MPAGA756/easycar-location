import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../data/dummy_users.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  bool get isAdmin => _currentUser?.role == 'admin';

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final user = dummyUsers.firstWhere(
        (u) => u.email == email.trim() && u.password == password.trim(),
      );
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    final exists = dummyUsers.any((u) => u.email == email.trim());
    if (exists) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newUser = UserModel(
      id: 'u${dummyUsers.length + 1}',
      name: name.trim(),
      email: email.trim(),
      password: password.trim(),
      role: 'client',
    );

    dummyUsers.add(newUser);
    _currentUser = newUser;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}