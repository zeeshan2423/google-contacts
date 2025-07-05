import 'package:google_contacts/core/constants/imports.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkStatus> {
  NetworkCubit() : super(const NetworkStatus(ConnectivityStatus.connected)) {
    _checkInitialConnection();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      emit(const NetworkStatus(ConnectivityStatus.disconnected));
    } else {
      emit(const NetworkStatus(ConnectivityStatus.connected));
    }
  }

  void _updateStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      emit(const NetworkStatus(ConnectivityStatus.disconnected));
    } else {
      emit(const NetworkStatus(ConnectivityStatus.connected));
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
