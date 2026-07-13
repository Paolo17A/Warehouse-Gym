import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/network/network_info.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final connectivityProvider = Provider<Connectivity>(
  (_) => sl<Connectivity>(),
);

final networkInfoProvider = Provider<NetworkInfo>(
  (_) => sl<NetworkInfo>(),
);
