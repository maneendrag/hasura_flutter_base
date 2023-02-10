import 'package:connectivity/connectivity.dart';
import 'package:efc_nc/_app/app.locator.dart';
import 'package:efc_nc/_services/util_service.dart';


class ConnectivityService {
  UtilsService _utils = locator<UtilsService>();
  Connectivity _connect = Connectivity();
  Future<ConnectivityResult> get status => _connect.checkConnectivity();

  Future<bool> checkConnection() async {
    try {
      ConnectivityResult res = await _connect.checkConnectivity();
      if (res == ConnectivityResult.none) {
        print("< ------------------No Internet ------------->");
        // _utils.showErrorSnackBar(
        //     msg: 'Please connect to Internet for better experience',
        //     title: "No Internet");
      } else {
        return true;
      }
    } catch (e, s) {
      print("$e , $s");
      print("error from check connection ${e.toString()}");
    }
    return false;
  }

  ConnectivityService() {
    _connect.checkConnectivity().then((res) {
      if (res == ConnectivityResult.none) {
        print('Please connect to Internet for better experience');
        // _utils.showErrorSnackBar(
        //     msg: 'Please connect to Internet for better experience',
        //     title: "No Internet");
      }
    }).catchError((e) {
      print("error from check connection ${e.toString()}");
    });
    _connect.onConnectivityChanged.listen((res) async {
      if (ConnectivityResult.none == res) {
        _utils.showSnackBar(
            title: "No internet",
            msg: "Please connect to Internet for better experience");
      }
    });
  }
}
