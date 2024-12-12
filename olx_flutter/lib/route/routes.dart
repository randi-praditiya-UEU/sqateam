import 'package:flutter/material.dart';
import '/login.dart';
import '/register.dart';
import '/main.dart';
import '/add_car.dart';
import '/view.dart';
import '/edit.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addCar = '/add_car';
  static const String viewCar = '/view_car';
  static const String editCar = '/edit_car';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case home:
        return MaterialPageRoute(
            builder: (_) => MyHomePage(title: 'Daftar Kendaraan Dijual'));
      case addCar:
        return MaterialPageRoute(builder: (_) => AddCarPage());
      case viewCar:
        final car = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ViewCarPage(car: car),
        );
      case editCar:
        final car = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditCarPage(
            car: car,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
