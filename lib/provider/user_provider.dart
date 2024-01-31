import 'package:flutter/cupertino.dart';

import 'package:somGram/models/user_modal.dart' as model;

import '../services/auth_methods.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethods _authMethods = AuthMethods();
  model.User get getUser => _user!;
  Future<void> updateUser() async {
    model.User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
