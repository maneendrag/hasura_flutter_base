
import 'package:efc_nc/screen/home/home_screen.dart';
import 'package:efc_nc/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:efc_nc/_services/api_service.dart';
import 'package:efc_nc/_services/connectivity_service.dart';
import 'package:efc_nc/_services/util_service.dart';


@StackedApp(routes:[
  MaterialRoute(page: SplashScreen, initial: true),
  MaterialRoute(
    page: HomeScreen,
  ),
], dependencies: [
  LazySingleton(classType: HttpService),
  LazySingleton(classType: SnackbarService),
  LazySingleton(classType: ConnectivityService),
  LazySingleton(classType: UtilsService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: BottomSheetService),

]
    ,logger: StackedLogger())class Appetup {}