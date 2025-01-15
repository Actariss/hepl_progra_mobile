import 'package:hepl_progra_mobile/main.dart';
import "package:flutter/material.dart";

class RouteManager {
  static Route<dynamic> generateroute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/home' :
        if (args is String){
        return MaterialPageRoute(
            builder: (_) => HomePage(
              data: args,
            ),
        );
        }
        return _errorRoute();
      case '/register' :
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      default:
        return _errorRoute();

    }
  }
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}