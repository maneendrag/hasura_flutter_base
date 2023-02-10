import 'package:efc_nc/_app/app.locator.dart';
import 'package:efc_nc/_app/app.logger.dart';
import 'package:efc_nc/_services/api_service.dart';
import 'package:efc_nc/_services/util_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:logger/logger.dart';
export 'package:hasura_connect/hasura_connect.dart';

extension IterableFirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isNotEmpty ? first : null;
}

extension IterableFirstOrDefault<E> on Iterable<E> {
  E firstOrDefault(E defaultValue) => isNotEmpty ? first : defaultValue;
}

abstract class CustomBaseViewModel extends BaseViewModel {
  Logger logg = Logger();

  UtilsService utilsService = locator<UtilsService>();
  NavigationService navService = locator<NavigationService>();
  HttpService httpService = locator<HttpService>();

  goBack() {
    navService.back();
  }

  String get todayDateIsoString {
    return todayDateTime.toIso8601String();
  }

  DateTime get todayDateTime {
    DateTime _now = DateTime.now();
    return DateTime(_now.year, _now.month, _now.day);
  }

  CustomBaseViewModel() {
    initLogger();
  }

  initLogger() {
    logg = getLogger("ViewModel");
  }

}

abstract class CustomReactiveViewModel extends ReactiveViewModel {
  Logger logg = Logger();
  UtilsService utilsService = locator<UtilsService>();
  NavigationService navService = locator<NavigationService>();
  HttpService httpService = locator<HttpService>();

  goBack() {
    navService.back();
  }

  // CustomReactiveViewModel() {
  //   initLogger();
  // }

  // initLogger() {
  //   logg = getLogger("ViewModel");
  // }
}
