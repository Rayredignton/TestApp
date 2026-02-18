// lib/core/network_vm.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'network_info.dart';

class NetworkVm extends ChangeNotifier {
  final NetworkInfo networkInfo;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  StreamSubscription<bool>? _subscription;

  NetworkVm(this.networkInfo) {
    _init();
  }

  Future<void> _init() async {
    _isOnline = await networkInfo.isConnected;
    notifyListeners();

    _subscription = networkInfo.onStatusChange.listen((status) {
      if (_isOnline != status) {
        _isOnline = status;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}