import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  User? _currentUser;
  bool _initialized = false; // 新增：标记是否已初始化

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  int? get currentUserId => _currentUser?.id;
  bool get initialized => _initialized; // 新增：获取初始化状态

  void setUser(User user) {
    _currentUser = user;
    _initialized = true;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _initialized = true;
    notifyListeners();
  }

  void markInitialized() { // 新增：标记为已初始化（但未登录）
    _initialized = true;
    notifyListeners();
  }
}