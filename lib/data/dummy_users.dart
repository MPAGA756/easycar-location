import '../models/user_model.dart';

final List<UserModel> dummyUsers = [
  UserModel(
    id: 'u1',
    name: 'Admin EasyCar',
    email: 'admin@easycar.com',
    password: 'admin123',
    role: 'admin',
  ),
  UserModel(
    id: 'u2',
    name: 'Jean Dupont',
    email: 'jean@gmail.com',
    password: 'jean123',
    role: 'client',
  ),
  UserModel(
    id: 'u3',
    name: 'Marie Martin',
    email: 'marie@gmail.com',
    password: 'marie123',
    role: 'client',
  ),
  UserModel(
    id: 'u4',
    name: 'Karim Bensalem',
    email: 'karim@gmail.com',
    password: 'karim123',
    role: 'client',
  ),
];