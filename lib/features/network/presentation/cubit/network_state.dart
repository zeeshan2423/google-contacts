part of 'network_cubit.dart';

enum ConnectivityStatus { connected, disconnected }

final class NetworkStatus {
  const NetworkStatus(this.status);
  final ConnectivityStatus status;
}
