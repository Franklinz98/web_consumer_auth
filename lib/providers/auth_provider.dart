import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  bool _authState = false;
  String _name = "John Doe";
  String _email = "john.doe@example.com";

  bool get isLogged => _authState;
  String get name => _name;
  String get email => _email;

  void connect(String name, String email) {
    _name = name;
    _email = email;
    _authState = true;
    notifyListeners();
  }

  void disconnect() {
    _name = "John Doe";
    _email = "john.doe@example.com";
    _authState = false;
    notifyListeners();
  }
}
